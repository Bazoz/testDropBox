//
//  MediaListItemView.swift
//  TestDropbox
//
//  Created by Yarik on 29.08.2023.
//

import SwiftUI

struct MediaListItemView: View {
    let mediaFile: MediaFile
    @State var cellWidth: CGFloat
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            
            PhotoView(filename: mediaFile.name)
                .frame(width: cellWidth, height: cellWidth)
                .shadow(radius: 4)
                .cornerRadius(8)
            
            VStack{
                Text(mediaFile.name)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
            
        }
        .padding()
    }
}
