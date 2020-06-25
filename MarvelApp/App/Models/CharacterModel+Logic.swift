//
//  CharacterModel+Logic.swift
//  MarvelApp
//
// 21/04/2020.
//   
//

import Foundation
import Combine
import UIKit
import SwiftUI

extension Character {
    
    func thumbnailUrl() -> URL? {
        if let path = thumbnail?.path, let extensionThumbnail = thumbnail?.thumbnailExtension {
            let urlString = URL(string: "\(path).\(extensionThumbnail)")
            return urlString
        } else {
            return nil
        }
    }
}
