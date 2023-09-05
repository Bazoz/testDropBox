//
//  ImageCacheService.swift
//  TestDropbox
//
//  Created by Yarik on 29.08.2023.
//

import UIKit

public class ImageCacheService {
    
    public static var shared = ImageCacheService()
    
    private init() {}
    
    private func getDirectoryURL() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    private func hashedFilename(prefix: String, originalFilename: String) -> String {
           let filenameHash = originalFilename.data(using: .utf8)?.base64EncodedString() ?? ""
           return "\(prefix)_\(filenameHash)"
       }
    
    public func getCachedFullImage(for filename: String) -> UIImage? {
        let prefixedFilename = hashedFilename(prefix: "fullImage", originalFilename: filename)
        if let fileURL = getDirectoryURL()?.appendingPathComponent(prefixedFilename),
           let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            return image
        }
        return nil
    }
    
    public func getCachedThumbnail(for filename: String) -> UIImage? {
        let prefixedFilename = hashedFilename(prefix: "thumbnail", originalFilename: filename)
        if let fileURL = getDirectoryURL()?.appendingPathComponent(prefixedFilename),
           let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            return image
        }
        return nil
    }
    
    public func getCachedVideoURL(for filename: String) -> URL? {
        let prefixedFilename = hashedFilename(prefix: "video", originalFilename: filename)
        let fileURL = getDirectoryURL()?.appendingPathComponent(prefixedFilename)
        if FileManager.default.fileExists(atPath: fileURL?.path ?? "") {
            return fileURL
        }
        return nil
    }
    
    public func saveFullImage(filename: String, image: UIImage?) {
        let prefixedFilename = hashedFilename(prefix: "fullImage", originalFilename: filename)
        if let fileURL = getDirectoryURL()?.appendingPathComponent(prefixedFilename),
           let resizedImageData = image?.jpegData(compressionQuality: 1.0) {
            try? resizedImageData.write(to: fileURL)
        }
    }
    
    public func saveThumbnail(filename: String, image: UIImage) {
        let prefixedFilename = hashedFilename(prefix: "thumbnail", originalFilename: filename)
        if let fileURL = getDirectoryURL()?.appendingPathComponent(prefixedFilename),
           let resizedImageData = image.jpegData(compressionQuality: 1.0) {
            try? resizedImageData.write(to: fileURL)
            
        }
    }
    
    public func saveVideo(filename: String, videoURL: URL) {
        let prefixedFilename = hashedFilename(prefix: "video", originalFilename: filename)
        if let fileURL = getDirectoryURL()?.appendingPathComponent(prefixedFilename) {
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.copyItem(at: videoURL, to: fileURL)
                } catch {
                    print("Error saving video: \(error)")
                }
            }
        }
    }
    
    public func deleteFile(at url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error deleting file: \(error)")
        }
    }
    
    public func getCachedFullImageURL(for imageName: String) -> URL? {
        let prefixedFilename = hashedFilename(prefix: "fullImage", originalFilename: imageName)
          if let fileURL = getDirectoryURL()?.appendingPathComponent(prefixedFilename) {
              if FileManager.default.fileExists(atPath: fileURL.path) {
                  return fileURL
              }
          }
          return nil
    }

}
