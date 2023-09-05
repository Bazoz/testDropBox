//
//  AuthenticationView.swift
//  TestDropbox
//
//  Created by Yarik on 29.08.2023.
//

import SwiftUI

struct AuthenticationView: View {
    @ObservedObject var viewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            Button("Увійти з Dropbox") {
                viewModel.authenticate()
            }
            .padding(16)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(16)
            
            if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
            }
        }
    }
}


struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        let dummyViewModel = AuthenticationViewModel()
        return AuthenticationView(viewModel: dummyViewModel)
    }
}

