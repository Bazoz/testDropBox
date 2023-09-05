//
//  ContentView.swift
//  TestDropbox
//
//  Created by Yarik on 29.08.2023.
//

import SwiftUI
import SwiftyDropbox

struct ContentView: View {
    @ObservedObject var authenticationViewModel = AuthenticationViewModel()
    
    var body: some View {
        VStack {
            Group {
                if authenticationViewModel.getAuthenticationStatus() {
                    MediaListView()
                } else {
                    AuthenticationView(viewModel: authenticationViewModel)
                }
            }
        }
        .onOpenURL { url in
            let oauthCompletion: DropboxOAuthCompletion = {
                if let authResult = $0 {
                    switch authResult {
                    case .success:
                        authenticationViewModel.saveAuthenticationStatus(value: true)
                        print("Success! User is logged into DropboxClientsManager.")
                    case .cancel:
                        print("Authorization flow was manually canceled by user!")
                    case .error(_, let description):
                        print("Error: \(String(describing: description))")
                    }
                }
            }
            DropboxClientsManager.handleRedirectURL(url, completion: oauthCompletion)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
