//
//  URL+Marvel.swift
//  MarvelApp
//
//  Created by Ignacio Acisclo on 17/04/2020.
//   
//

import Foundation

extension URL{
    
    static private let baseURL = "https://gateway.marvel.com/"
    
    private enum Endpoint: String {
        case characters = "v1/public/characters"
        case comics = "v1/public/comics"
    }
    
    static func characters(_ characterId: String? = nil, limit: Int, offset: Int, nameStartsWith: String? = nil) -> URL? {
        var endPoint = Endpoint.characters.rawValue
        var pageParams = ""
        if let _ = characterId {
            endPoint = endPoint + "/\(characterId!)"
        } else {
            pageParams = "&limit=\(limit)&offset=\(offset)"
        }
        if let name = nameStartsWith, name.count > 0 {
            pageParams = "&nameStartsWith=\(name)"
        }
        let urlString = "\(baseURL)\(endPoint)?apikey=\(Secret.publicKey)&hash=\(Secret.md5)&ts=\(Secret.ts)\(pageParams)"
        return URL(string: urlString)
    }
    
    static func comics(_ comicId: String? = nil) -> URL{
        var endPoint = Endpoint.comics.rawValue
        if let _ = comicId {
            endPoint = endPoint + "/\(comicId!)"
        }
        return URL(string: "\(baseURL)\(endPoint)?apikey=\(Secret.publicKey)&hash=\(Secret.md5)&ts=\(Secret.ts)")!
        
    }
    
}
