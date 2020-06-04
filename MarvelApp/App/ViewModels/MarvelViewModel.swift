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
    private let input = PassthroughSubject<Event, Never>()
    
    @Published var characters: [Character] = []
    @Published private(set) var state: State = State.idle
    
    var searchText : String = "" {
        willSet {
            self.page = 0
            self.send(event: .onStartLoadingCharacters)
        }
    }
    
    var page: Int = 0
    
    init() {
        Publishers.system(
            initial: state,
            reduce: reduce,
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
}

extension MarvelViewModel {
        
    enum State: Equatable {
        static func == (lhs: MarvelViewModel.State, rhs: MarvelViewModel.State) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle):
                return true
            case (.loading, .loading):
                return true
            case (.loadingNewPage, .loadingNewPage):
                return true
            default:
                return false
            }
        }
        
        case idle
        case loading
        case loaded([Character])
        case loadingNewPage
        case error(Error)
        
        var characters: [Character]? {
            get {
                guard case .loaded(let characters) = self else {
                    return nil
                }
                return characters
            }
        }
    }
    
    enum Event {
        case onAppear
        case onStartLoadingCharacters
        case onSelectCharacter(Int)
        case onCharactersLoaded([Character])
        case onFailedToLoadCharacters(Error)
    }
    
    
    func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle:
                switch event {
                case .onAppear:
                    return .loading
                default:
                    return state
                }
        case .loading,
             .loadingNewPage:
                switch event {
                case .onFailedToLoadCharacters(let error):
                    return .error(error)
                case .onCharactersLoaded(let newCharacters):
                   if self.page > 0 && !self.characters.elementsEqual(newCharacters, by: { (character, result) -> Bool in
                        character.id==result.id
                    }) {
                        self.characters.append(contentsOf: newCharacters)
                    } else {
                        self.characters = newCharacters
                    }
                    return .loaded(characters)
                default:
                    return state
                }
        case .loaded:
            switch event {
            case .onStartLoadingCharacters:
                return .loadingNewPage
            default:
                return state
            }
        default:
            return state
        }
    }
    
    func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard [.loading, .loadingNewPage].contains(state) else { return Empty().eraseToAnyPublisher() }
            return MarvelAPI.characters(page: self.page, searchTerm: self.searchText).map({Event.onCharactersLoaded($0.data?.results ?? [])}).catch { Just(Event.onFailedToLoadCharacters($0)) }.eraseToAnyPublisher()
        }
    }
    
    func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
        Feedback { _ in input }
    }
    
}
