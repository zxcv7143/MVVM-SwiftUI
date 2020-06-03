//
//  ImageLoader.swift
//  MarvelApp
//
//  Created by Anton Zuev on 20/04/2020.
//  Copyright © 2020 Ignacio Acisclo. All rights reserved.
//

import Foundation

import Combine
import UIKit

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private(set) var isLoading = false
    
    private let url: URL?
    private var cache: ImageCache?
    private var cancellable: AnyCancellable?
        
    init(url: URL?, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func load() {
        guard let url = self.url else { return }
        
        guard !isLoading else { return }

        if let image = cache?[url] {
            self.image = image
            return
        }
        
        cancellable = MarvelAPI.image(url: url)
            .map { UIImage(data: $0) }
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveOutput: { [weak self] in self?.cache($0) },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .assign(to: \.image, on: self)
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
    
    private func cache(_ image: UIImage?) {
        if let url = self.url {
            image.map { cache?[url] = $0 }
        }
    }
}
