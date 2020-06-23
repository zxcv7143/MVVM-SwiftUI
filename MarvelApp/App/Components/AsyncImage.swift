//
//  AsyncImage.swift
//  MarvelApp
//
//  Created by Anton Zuev on 20/04/2020.
//   
//

import Foundation

import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder?
    
    init(url: URL?, cache: ImageCache? = nil, placeholder: Placeholder? = nil) {
        loader = ImageLoader(url: url, cache: cache)
        self.placeholder = placeholder
        loader.load()
    }
    
    var body: some View {
        image
//            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    private var image: some View {
        Group {
            if loader.image != nil {
                Image(uiImage: loader.image!).resizable()
            } else {
                placeholder
            }
        }
    }
}
