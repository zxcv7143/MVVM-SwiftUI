//
//  MavelViewModel.swift
//  MarvelApp
//
//  Created by Anton Zuev on 15/04/2020.
//  Copyright © 2020 Ignacio Acisclo. All rights reserved.
//

import UIKit
import Combine
import SwiftUI

class MarvelViewModel: ObservableObject {
    
    private var cancellableSet: Set<AnyCancellable> = []
    @Published var characters: [Character] = []
    @Published private(set) var state: State = State.idle
    @Published var searchText : String = ""
    @Published var page: Int = 0
    
    private let input = PassthroughSubject<Event, Never>()
    
    init() {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                whenLoading(),
                userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &cancellableSet)
    }
    
    deinit {
        cancellableSet.removeAll()
    }
    
    func send(event: Event) {
        input.send(event)
    }
        
//    func loadCharacters(searchTerm: String = "") {
//        do {
//            self.state = MarvelViewModel.reduce(self.state, Event.onStartLoadingCharacters)
//            try MarvelAPI.characters(page: self.page, searchTerm: searchTerm).sink(receiveCompletion: { completion in
//                switch completion {
//                case .failure(let error):
//                    switch error {
//                    case .serverError(code: let code, message: let reason):
//                        print("Server error: \(code), reason: \(reason)")
//                        self.state = MarvelViewModel.reduce(self.state, Event.onFailedToLoadCharacters(error))
//                    case .decodingError:
//                        print("Decoding error \(error)")
//                        self.state = MarvelViewModel.reduce(self.state, Event.onFailedToLoadCharacters(error))
//                    case .internalError:
//                        print("Internal error \(error)")
//                        self.state = MarvelViewModel.reduce(self.state, Event.onFailedToLoadCharacters(error))
//                    }
//                default: break
//                }
//            }) { (charactersResponse) in
//                if let results = charactersResponse.data?.results {
//                    self.state = MarvelViewModel.reduce(self.state, Event.onCharactersLoaded(results))
//                    print("Characters: \(results)")
//                    if self.page > 0 && !self.characters.elementsEqual(results, by: { (character, result) -> Bool in
//                        character.id==result.id
//                    }) {
//                        self.characters.append(contentsOf: results)
//                    } else {
//                        self.characters = results
//                    }
//                }
//            }
//            .store(in: &cancellableSet)
//        }
//        catch {
//             print("Unexpected error: \(error).")
//        }
//    }
}

extension MarvelViewModel {
        
    enum State: Equatable {
        static func == (lhs: MarvelViewModel.State, rhs: MarvelViewModel.State) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle):
                return true
            case (.loading, .loading):
                return true
            default:
                return false
            }
        }
        
        case idle
        case loading
        case loaded([Character])
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onStartLoadingCharacters
        case onSelectCharacter(Int)
        case onCharactersLoaded([Character])
        case onFailedToLoadCharacters(Error)
    }
    
    
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle:
                switch event {
                case .onAppear:
                    return .loading
                default:
                    return state
                }
        case .loading:
                switch event {
                case .onFailedToLoadCharacters(let error):
                    return .error(error)
                case .onCharactersLoaded(let characters):
                    return .loaded(characters)
                default:
                    return state
                }
        case .loaded:
            return state
        case .error:
                return state
        }
    }
    
    func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            return MarvelAPI.characters(page: self.page, searchTerm: self.searchText).map({Event.onCharactersLoaded($0.data?.results ?? [])}).catch { Just(Event.onFailedToLoadCharacters($0)) }.eraseToAnyPublisher()
        }
    }
    
    func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
}
