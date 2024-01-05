//
//  CacheAsyncImage.swift
//  SpotifyClone
//
//  Created by Edson Dario Toledo Gonzalez on 26/12/23.
//

import SwiftUI

// TODO: Pass the imageCache instance in the constructor instead of using a static function
// We can inject the image cache as an environment object
// Advantages: Avoid data races using actors. Handle image states to avoid loading the same resource twice.

struct CacheAsyncImage<Content, Placeholder>: View where Content: View, Placeholder: View {
    
    private let url: URL?
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    
    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        if let url = url {
            if let cached = ImageCache.cache[url] {
                content(cached)
            } else {
                AsyncImage(url: url) { image in
                    content(image)
                        .onAppear {
                            cacheImage(url: url, image: image)
                        }
                } placeholder: {
                    placeholder()
                }
            }
        } else {
            placeholder()
        }
    }
    
    private func cacheImage(url: URL, image: Image) {
        ImageCache.cache[url] = image
    }
}

fileprivate class ImageCache {
    
    static var cache: [URL: Image] = [:]
    
    static subscript(url: URL) -> Image? {
        get { Self.cache[url] }
        set { Self.cache[url] = newValue }
    }
}

#Preview {
    CacheAsyncImage(
        url: URL(string: "https://i.scdn.co/image/ab6761610000e5eb9ac284d0d6afcb53a65558b3")
    ) { image in
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
    } placeholder: {
        Color.primaryGray.opacity(0.5)
    }
}
