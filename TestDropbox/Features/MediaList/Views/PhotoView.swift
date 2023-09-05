//
//  PhotoView.swift
//  TestDropbox
//
//  Created by Yarik on 29.08.2023.
//

import SwiftUI

struct PhotoView: View {
    @StateObject private var viewModel = PhotoViewModel()
    @State private var image: UIImage?
    var filename: String?
    
    var body: some View {
        if let filename = self.filename {
            if let cachedImage = viewModel.getCachedImage(for: filename) {
                Image(uiImage: cachedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
                    .onAppear {
                        viewModel.downloadThumbnail(filename: filename) { downloadedImage in
                            self.image = downloadedImage
                        }
                    }
            }
        } else {
            Text("No photos to display")
        }
    }
}
