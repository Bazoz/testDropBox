//
//  MediaFile.swift
//  TestDropbox
//
//  Created by Yarik on 29.08.2023.
//

import SwiftUI

enum MediaType: String {
    case photo
    case video
    
    init?(from filename: String) {
        if filename.hasSuffix(".jpeg") || filename.hasSuffix(".png") || filename.hasSuffix(".jpg") {
            self = .photo
        } else if filename.hasSuffix(".mp4") {
            self = .video
        } else {
            return nil
        }
    }
}

struct MediaFile: Identifiable {
    let id: UUID = UUID()
    let name: String
    let mediaType: MediaType
}
