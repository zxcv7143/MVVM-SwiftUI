//
//  Secret.swift
//  MarvelApp
//
//  Created by Ignacio Acisclo on 17/04/2020.
//  Copyright © 2020 Ignacio Acisclo. All rights reserved.
//
import Foundation
import CryptoKit

struct Secret {
    
    static private let privateKey = "23ec56ac540c405b94063afddc79bcda1fcac842"
    static let publicKey = "ee77e6d97c8a8329dce2c8bff21d88c1"
    static let ts = String(Date().timeIntervalSince1970)
    
    static var md5: String {
        let digest = Insecure.MD5.hash(data: "\(ts)\(privateKey)\(publicKey)".data(using: .utf8) ?? Data())
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
