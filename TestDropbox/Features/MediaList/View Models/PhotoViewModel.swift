//
//  PhotoViewModel.swift
//  TestDropbox
//
//  Created by Yarik on 29.08.2023.
//
import SwiftUI
import SwiftyDropbox

class PhotoViewModel: ObservableObject {
    private let cacheService = ImageCacheService.shared
    private var dropboxService = DropboxService.shared
    
    func getCachedImage(for filename: String) -> UIImage? {
        return cacheService.getCachedThumbnail(for: filename)
    }
    
    func downloadThumbnail(filename: String, completion: @escaping (UIImage?) -> Void) async {
        await dropboxService.downloadThumbnail(filename: filename) { image in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
