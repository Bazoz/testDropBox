//
//  DropboxTokenManager.swift
//  TestDropbox
//
//  Created by Yarik on 07.09.2023.
//

import Foundation

struct DropboxTokenManager {
    static let shared = DropboxTokenManager()
    
    private init() {}
    
    private let defaults = UserDefaults.standard
    
    func saveAccessToken(_ token: String) {
        defaults.set(token, forKey: "dropboxAccessTokened")
    }
    
    func getAccessToken() -> String? {
        return defaults.string(forKey: "dropboxAccessTokened")
    }
    
    func saveExpiresIn(_ timestamp: TimeInterval) {
        defaults.set(timestamp, forKey: "dropboxExpiresInToken")
    }
    
    func getExpiresIn() -> TimeInterval? {
        return defaults.object(forKey: "dropboxExpiresInToken") as? TimeInterval
    }
    
    public func getRefreshToken() -> String? {
        return "t7-nSV242YoAAAAAAAAAAUJMKx7PoiPheFCcc6EW0Zxs3yTYQUDnOlGKxicYtkzA"
    }
    
    private func setExpiresInToken() {
        let calendar = Calendar.current
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.hour = 4
        dateComponents.minute = -1
        
        if let newDate = calendar.date(byAdding: dateComponents, to: currentDate) {
            let timeInterval = newDate.timeIntervalSince1970
            saveExpiresIn(timeInterval)
        }
    }
    
    func isTokenExpired() -> Bool {
        guard let timestamp = getExpiresIn() else { return true }
        let currentTime = Date().timeIntervalSince1970
        return timestamp <= currentTime
    }
}
