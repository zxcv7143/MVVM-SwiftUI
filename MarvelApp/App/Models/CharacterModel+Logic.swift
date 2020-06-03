//
//  CharacterModel+Logic.swift
//  MarvelApp
//
//  Created by Ignacio Acisclo on 21/04/2020.
//  Copyright © 2020 Ignacio Acisclo. All rights reserved.
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
