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
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read", "files.metadata.read", "files.metadata.write", "files.content.read", "files.content.write"], includeGrantedScopes: false)

        DropboxClientsManager.authorizeFromControllerV2(
            UIApplication.shared,
            controller: nil,
            loadingStatusDelegate: nil,
            openURL: {(url: URL) -> Void in UIApplication.shared.open(url)},
            scopeRequest: scopeRequest
        )
    }
    
    func saveAuthenticationStatus(value: Bool) {
        self.isAuthenticated = value
        UserDefaults.standard.set(value, forKey: "isAuthenticat")
    }
    
    func getAuthenticationStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: "isAuthenticat")
    }
    
}
