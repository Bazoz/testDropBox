//
//  TestDropboxApp.swift
//  TestDropbox
//
//  Created by Yarik on 29.08.2023.
//

import SwiftUI
import SwiftyDropbox

@main
struct TestDropboxApp: App {
    @ObservedObject var authenticationViewModel = AuthenticationViewModel()

    init() {
        DropboxClientsManager.setupWithAppKey(Constants.dropboxToken)
        setupAuthorizedClient {}
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if authenticationViewModel.getAuthenticationStatus() {
                    MediaListView()
                } else {
                    MediaListView()
                        .onAppear {
                            if !authenticationViewModel.getAuthenticationStatus() {
                                setupAuthorizedClient {
                                    authenticationViewModel.saveAuthenticationStatus(value: true)
                                }
                            }
                        }
                }
            }
        }
    }

    private func setupAuthorizedClient(completion: @escaping () -> Void?) {
        if DropboxTokenManager.shared.isTokenExpired() {
            Task {
                do {
                    try await DropboxService.shared.refreshToken()
                    setAuthorizedClient()
                    completion()
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            setAuthorizedClient()
        }
    }
    
    private func setAuthorizedClient() {
        if let accessToken = DropboxTokenManager.shared.getAccessToken() {
            let client = DropboxClient(accessToken: accessToken)
            DropboxClientsManager.authorizedClient = client
        }
    }
}
