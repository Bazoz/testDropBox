//
//  MediaDetailViewModel.swift
//  TestDropbox
//
//  Created by Yarik on 29.08.2023.
//

import SwiftUI
import SwiftyDropbox

class MediaDetailViewModel: ObservableObject {
    @Published var selectedMedia: MediaFile?
    private var dropboxService = DropboxService.shared
    private let cacheService = ImageCacheService.shared
    
    func getCachedImage(for filename: String) -> UIImage? {
        return cacheService.getCachedFullImage(for: filename)
    }
    
    func getCachedVideo(for filename: String) -> URL? {
        return cacheService.getCachedVideoURL(for: filename)
    }
    
    func downloadFile(filename: String, completion: @escaping (UIImage?, URL?) -> Void) async {
        await dropboxService.downloadFile(filename: filename) { (image, videoURL) in
            DispatchQueue.main.async {
                completion(image, videoURL)
            }
        }
    }
}


