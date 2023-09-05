//
//  AuthenticationViewModel.swift
//  TestDropbox
//
//  Created by Yarik on 29.08.2023.
//

import Foundation
import SwiftUI
import SwiftyDropbox

class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    
    func authenticate() {
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read", "files.metadata.read", "files.content.read"], includeGrantedScopes: false)
        DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: nil, openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) })
    }
    
    private func replayToken() {
        let accessToken = "sl.BldyZvHxgwyZqeMTgCu0QSush7ZRBeIQ-EdZuDPCDV-iJMFXWrQYsXboG9tKXzv1CEWU5EhKEZYIejm8nJo2mLhlR7aPCDeB5SgtksMCnAz9IW6XWTYBVOrs5P0SuMporoifAat0wlMw_0lqNOrjL8w"
        let client = DropboxClient(accessToken: accessToken)
        DropboxClientsManager.authorizedClient = client
    }
    
    func saveAuthenticationStatus(value: Bool) {
        self.isAuthenticated = value
        replayToken()
        UserDefaults.standard.set(value, forKey: "isAuthenticated")
    }
    
    func getAuthenticationStatus() -> Bool {
        replayToken()
        return UserDefaults.standard.bool(forKey: "isAuthenticated")
    }
    
}
