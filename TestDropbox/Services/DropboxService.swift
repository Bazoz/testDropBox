//
//  DropboxService.swift
//  TestDropbox
//
//  Created by Yarik on 29.08.2023.
//

import UIKit
import SwiftyDropbox
import Alamofire

public class DropboxService {
    static let shared = DropboxService()
    private let cacheService = ImageCacheService.shared
    
    private init() {}
    
    let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let UUID = Foundation.UUID().uuidString
        let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
        return directoryURL.appendingPathComponent(pathComponent)
    }
    
    public func downloadFile(filename: String, completion: @escaping (UIImage?, URL?) -> Void) async {
        await checkToken()
        
        DropboxClientsManager.authorizedClient?.files.download(path: "/\(filename)", overwrite: true, destination: destination)
            .response { [weak self] response, error in
                guard let `self` = self else { return }
                var image: UIImage? = nil
                var videoURL: URL? = nil
                if let (_, url) = response {
                    if filename.hasSuffix(".jpg") || filename.hasSuffix(".jpeg") || filename.hasSuffix(".png") {
                        if let data = try? Data(contentsOf: url),
                           let img = UIImage(data: data) {
                            image = img
                            self.cacheService.saveFullImage(filename: filename, image: img)
                            self.cacheService.deleteFile(at: url)
                        }
                    } else if filename.hasSuffix(".mp4") || filename.hasSuffix(".mov") {
                        videoURL = url
                        self.cacheService.saveVideo(filename: filename, videoURL: url)
                    }
                }
                completion(image, videoURL)
            }
    }
    
    public func downloadThumbnail(filename: String, completion: @escaping (UIImage?) -> Void) async {
        await checkToken()
        
        DropboxClientsManager.authorizedClient?.files.getThumbnail(path: "/\(filename)", format: .png, size: .w256h256, destination: destination)
            .response { [weak self] response, error  in
                guard let `self` = self else { return }
                if let (_, url) = response,
                   let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    self.cacheService.saveThumbnail(filename: filename, image: image)
                    self.cacheService.deleteFile(at: url)
                    completion(image)
                } else {
                    completion(nil)
                }
            }
    }
    
    public func checkToken() async {
        if DropboxTokenManager.shared.isTokenExpired() {
            Task {
                do {
                    try await refreshToken()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    public func refreshToken() async throws {
        let tokenURL = URL(string: "https://api.dropbox.com/oauth2/token")!
        
        guard let refreshToken = DropboxTokenManager.shared.getRefreshToken(), !refreshToken.isEmpty else { throw NSError(domain: "Refresh token", code: 1) }
        
        var request = try! URLRequest(url: tokenURL, method: .post)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let params = "refresh_token=\(refreshToken)&grant_type=refresh_token&client_id=lc2s8lwauex374q&client_secret=6srch7v2yviahx7"
        
        
        request.httpBody = params.data(using: .ascii)
        let response = try await URLSession.shared.data(for: request)
        guard let decodedResponse = try? (JSONSerialization.jsonObject(with: response.0) as? [String : Any]), let token = decodedResponse["access_token"] as? String else {
            throw NSError(domain: "Refresh token", code: 1)
        }
        
        DropboxTokenManager.shared.saveAccessToken(token)
    }
}
