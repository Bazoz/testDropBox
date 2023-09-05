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
    
    init() {
        DropboxClientsManager.setupWithAppKey(Constants.dropboxToken)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
