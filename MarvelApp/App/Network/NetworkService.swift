//
//  NetworkService.swift
//  MarvelApp
//
//  Created by Anton Zuev on 15/04/2020.
//   
//
import UIKit
import Combine

enum HTTPMethod: String {
    case GET
}

struct NetworkService {
    
    func send<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, APIError> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .mapError{ APIError.serverError(code: $0.errorCode, message: $0.localizedDescription) }
            .map { $0.data }
            .decode(type: T.self, decoder: decoder)
            .print()
            .mapError { _ in APIError.decodingError }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func send(_ request: URLRequest) -> AnyPublisher<Data, URLError> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map { $0.data }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
