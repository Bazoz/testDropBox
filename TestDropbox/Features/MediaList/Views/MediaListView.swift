//
//  MediaListView.swift
//  TestDropbox
//
//  Created by Yarik on 29.08.2023.
//

import SwiftUI

struct MediaListView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    @StateObject private var viewModel: MediaListViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: MediaListViewModel())
    }
    
    var columns: [GridItem] {
        if horizontalSizeClass == .regular && verticalSizeClass == .regular {
            return Array(repeating: GridItem(.flexible()), count: 4)
        } else if horizontalSizeClass == .compact && verticalSizeClass == .regular {
            return Array(repeating: GridItem(.flexible()), count: 2)
        } else {
            return Array(repeating: GridItem(.flexible()), count: 4)
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let itemWidth = (geometry.size.width - CGFloat(columns.count) * 16) / CGFloat(columns.count)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.mediaFiles, id: \.id) { mediaFile in
                            NavigationLink {
                                MediaDetailView(file: mediaFile)
                            } label: {
                                MediaListItemView(mediaFile: mediaFile, cellWidth: itemWidth)
                                    .accessibilityIdentifier("item_\(mediaFile.id)")
                                    .task {
                                        if viewModel.hasReachedEnd(of: mediaFile) && !viewModel.isFetching {
                                            await viewModel.fetchNextSetOfFiles()
                                        }
                                    }
                            }
                        }
                    }
                    .padding()
                    .accessibilityIdentifier("imageGrid")
                }
                .refreshable {
                    await viewModel.loadMediaFiles()
                }
                .overlay(alignment: .bottom) {
                    if viewModel.isFetching {
                        ProgressView()
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            Task {
                await viewModel.loadMediaFiles()
            }
        }
    }
}
