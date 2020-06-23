//
//  MarvelAPI+Request.swift
//  MarvelApp
//
//  Created by Ignacio Acisclo on 17/04/2020.
//   
//

import Combine
import Foundation


extension MarvelAPI {
    
    static func characters(page: Int = 0, characterId: String? = nil, searchTerm: String? = nil) -> AnyPublisher<CharacterResponse, APIError> {
        let pageNumber = (page < 0 ? 0 : page)
        
        guard let url = URL.characters(limit: 20, offset: (pageNumber * 20), nameStartsWith: searchTerm) else {
            return Empty().eraseToAnyPublisher()
        }
        return send(url, method: .GET)
    }

    static func comics(comicId: String? = nil) -> AnyPublisher<ComicResponse, APIError> {
        return send(URL.comics(comicId), method: .GET)
    }
    
    static func image(url: URL) -> AnyPublisher<Data, URLError> {
        return send(url)
    }
}

