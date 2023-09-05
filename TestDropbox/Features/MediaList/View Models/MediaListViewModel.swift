//
//  MediaListViewModel.swift
//  TestDropbox
//
//  Created by Yarik on 29.08.2023.
//

import SwiftUI
import SwiftyDropbox

final class MediaListViewModel: ObservableObject {
    @Published var mediaFiles: [MediaFile] = []
    @Published var errorMessage: String?
    @Published private(set) var _viewState: ViewState?
    
    private let _itemsPerPage: UInt32 = 8
    private var _cursor: String?
    private var _isLastItem = false
    
    var isLoading: Bool {
        _viewState == .loading
    }
    
    var isFetching: Bool {
        _viewState == .fetching
    }
    
    @MainActor
    func loadMediaFiles() async {
        reset()
        guard let client = DropboxClientsManager.authorizedClient else { return }
        
        _viewState = .loading
        
        await processMediaFiles(using: client, cursor: nil)
        
        _viewState = .finished
    }
    
    @MainActor
    func fetchNextSetOfFiles() async {
        guard let cursor = _cursor, let client = DropboxClientsManager.authorizedClient, !_isLastItem else { return }
        
        _viewState = .fetching
        
        await processMediaFiles(using: client, cursor: cursor)
        
        _viewState = .finished
    }
    
    private func processMediaFiles(using client: DropboxClient, cursor: String?) async {
        do {
            var result: Files.ListFolderResult?
            var error: Any?
            
            if let cursor = cursor {
                (result, error) = try await withCheckedThrowingContinuation { continuation in
                    client.files.listFolderContinue(cursor: cursor)
                        .response { response, error in
                            continuation.resume(returning: (response, error))
                        }
                }
            } else {
                (result, error) = try await withCheckedThrowingContinuation { continuation in
                    client.files.listFolder(path: "", limit: _itemsPerPage)
                        .response { response, error in
                            continuation.resume(returning: (response, error))
                        }
                }
            }
            
            if let result = result {
                self.addMediaFilesFromResult(from: result)
            } else if let callError = error as? CallError<Files.ListFolderError> {
                self.errorMessage = "Error loading media files: \(callError)"
            } else if let continueError = error as? CallError<Files.ListFolderContinueError> {
                self.errorMessage = "Error continuing listFolder: \(continueError)"
            } else {
                self.errorMessage = "Unexpected error: \(error ?? "unknown")"
            }
        } catch {
            errorMessage = "Error processing media files: \(error)"
        }
    }
    
    private func addMediaFilesFromResult(from result: Files.ListFolderResult) {
        let mediaFiles = result.entries.compactMap { entry in
            if let mediaType = MediaType(from: entry.name) {
                return MediaFile(name: entry.name, mediaType: mediaType)
            }
            return nil
        }
        _cursor = result.cursor
        if result.entries.count < _itemsPerPage {
            _isLastItem = true
        }
        DispatchQueue.main.async {
            self.mediaFiles.append(contentsOf: mediaFiles)
        }
    }
    
    func hasReachedEnd(of mediaFile: MediaFile) -> Bool {
        return mediaFiles.last?.id == mediaFile.id
    }
}


extension MediaListViewModel {
    enum ViewState {
        case fetching
        case loading
        case finished
    }
}


private extension MediaListViewModel {
    func reset() {
        if _viewState == .finished {
            mediaFiles.removeAll()
            _viewState = nil
            _cursor = nil
            _isLastItem = false
        }
    }
}
