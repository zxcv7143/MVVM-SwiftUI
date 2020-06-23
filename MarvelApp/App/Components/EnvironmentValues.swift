//
//  EnvironmetValues.swift
//  MarvelApp
//
//  Created by Anton Zuev on 20/04/2020.
//   
//
import SwiftUI

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
