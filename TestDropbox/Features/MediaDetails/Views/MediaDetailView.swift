//
//  MediaDetailView.swift
//  TestDropbox
//
//  Created by Yarik on 29.08.2023.
//

import SwiftUI
import AVKit

struct MediaDetailView: View {
    var viewModel: MediaDetailViewModel = MediaDetailViewModel()
    var file: MediaFile
    @State private var image: UIImage?
    @State var player: AVPlayer?
    
    var body: some View {
        ScrollView {
            VStack {
                if file.mediaType == .photo {
                    if let cachedImage = viewModel.getCachedImage(for: file.name) {
                        Image(uiImage: cachedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        
                    }  else if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        ProgressView()
                            .onAppear {
                                Task {
                                    await viewModel.downloadFile(filename: file.name) { downloadedImage, _ in
                                        if let downloadedImage = downloadedImage {
                                            self.image = downloadedImage
                                        }
                                    }
                                }
                            }
                    }
                } else {
                    if let cachedVideoURL = viewModel.getCachedVideo(for: file.name) {
                        if let videoData = try? Data(contentsOf: cachedVideoURL), let playerItem = getPlayer(videoData: videoData) {
                            VideoPlayer(player: playerItem)
                                .aspectRatio(contentMode: .fit)
                        }
                    } else if let player = player {
                        VideoPlayer(player: player)
                            .aspectRatio(contentMode: .fit)
                    } else {
                        ProgressView()
                            .onAppear {
                                Task{
                                    await viewModel.downloadFile(filename: file.name, completion: { _, urlVideo in
                                        if let urlVideo = urlVideo, let videoData = try? Data(contentsOf: urlVideo), let playerItem = getPlayer(videoData: videoData) {
                                            player = playerItem
                                        }
                                    })
                                }
                            }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Name: \(file.name)")
                            .font(.headline)
                    }
                }
                .padding(16)
                .foregroundColor(.secondary)
                .background(.gray.opacity(0.2))
                .cornerRadius(16)
                
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func getPlayer(videoData: Data) -> AVPlayer? {
        if let playerItem = createPlayerItem(from: videoData) {
            return AVPlayer(playerItem: playerItem)
        }
        return nil
    }
    
    private func createPlayerItem(from videoData: Data) -> AVPlayerItem? {
        let temporaryURL = FileManager.default.temporaryDirectory.appendingPathComponent("tempVideo.mp4")
        do {
            try videoData.write(to: temporaryURL)
            let asset = AVAsset(url: temporaryURL)
            let playerItem = AVPlayerItem(asset: asset)
            return playerItem
        } catch {
            print("Error creating player item: \(error)")
        }
        
        return nil
    }
}
