//
//  ComicResponse.swift
//  MarvelApp
//
//  Created by Anton Zuev on 21/04/2020.
//   
//

import Foundation

// MARK: - ComicResponse
struct ComicResponse: Codable {
    let code: Int?
    let status, copyright, attributionText, attributionHTML: String?
    let etag: String?
    let data: ResultClass?
}

// MARK: - DataClass
struct ResultClass: Codable {
    let offset, limit, total, count: Int?
    var results: [Comic]?
}

// MARK: - Result
struct Comic: Codable {
    let id, digitalID: Int?
    let title: String?
    let issueNumber: Int?
    let variantDescription: String
    let resultDescription: String?
    let modified: String?
    let isbn: String?
    let upc: String?
    let diamondCode: String?
    let ean, issn: String?
    let format: Format?
    let pageCount: Int?
    let textObjects: [TextObject]?
    let resourceURI: String?
    let urls: [ComicURLElement]?
    let series: Series?
    let variants: [Series]?
    let collections: [Collections]?
    let collectedIssues: [Series]?
    let dates: [DateElement]?
    let prices: [Price]?
    let thumbnail: Thumbnail?
    let images: [Thumbnail]?
    let creators: Creators?
    let characters: Characters?
    let stories: Stories?
    let events: Characters?

    enum CodingKeys: String, CodingKey {
        case id
        case digitalID
        case title, issueNumber, variantDescription
        case resultDescription
        case modified, isbn, upc, diamondCode, ean, issn, format, pageCount, textObjects, resourceURI, urls, series, variants, collections, collectedIssues, dates, prices, thumbnail, images, creators, characters, stories, events
    }
}

// MARK: Collections
struct Collections: Codable {
    let resourceURI: String
    let name: String
}

// MARK: - Characters
struct Characters: Codable {
    let available: Int
    let collectionURI: String
    let items: [Series]
    let returned: Int
}

// MARK: - Series
struct Series: Codable {
    let resourceURI: String
    let name: String
}

// MARK: - Creators
struct Creators: Codable {
    let available: Int
    let collectionURI: String
    let items: [CreatorsItem]
    let returned: Int
}

// MARK: - CreatorsItem
struct CreatorsItem: Codable {
    let resourceURI: String
    let name: String
    let role: Role
}

enum Role: String, Codable {
    case colorist = "colorist"
    case editor = "editor"
    case inker = "inker"
    case letterer = "letterer"
    case penciler = "penciler"
    case penciller = "penciller"
    case pencillerCover = "penciller (cover)"
    case writer = "writer"
}

// MARK: - DateElement
struct DateElement: Codable {
    let type: DateType
    let date: String
}

enum DateType: String, Codable {
    case focDate = "focDate"
    case onsaleDate = "onsaleDate"
}

enum Format: String, Codable {
    case comic = "Comic"
    case empty = ""
    case tradePaperback = "Trade Paperback"
}

// MARK: - Price
struct Price: Codable {
    let type: String?
    let price: Double?
}

// MARK: - TextObject
struct TextObject: Codable {
    let type: String?
    let language: String?
    let text: String?
}

// MARK: - URLElement
struct ComicURLElement: Codable {
    let type: URLType?
    let url: String?
}

