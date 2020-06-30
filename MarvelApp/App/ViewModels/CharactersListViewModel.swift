//
//  MavelViewModel.swift
//  MarvelApp
//
//  Created by Anton Zuev on 15/04/2020.
//   
//

import UIKit
import Combine
import SwiftUI

enum ModelDataState: Equatable {
    static func == (lhs: ModelDataState, rhs: ModelDataState) -> Bool {
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
    case loaded
    case error(Error)
}


struct CharactersListState {
    var characters: [Character] = []
    var dataState: ModelDataState = .idle
    var page: Int = 0
    var searchTerm: CurrentValueSubject<String, Never> = CurrentValueSubject<String, Never>("")
    
    mutating func changeViewModelState(newViewModelState: ModelDataState) {
        dataState = newViewModelState
    }
    
    mutating func changePage(newPageNumber: Int){
        page = newPageNumber
    }
}

enum CharacterListInput {
    case reloadPage
    case nextPage
    case newSearch
}

class CharactersListViewModel: ViewModel {
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    @Published
    var state: CharactersListState

    init(state: CharactersListState) {
        self.state = state
        self.state.changeViewModelState(newViewModelState: .loading)
        loadCharacters(searchTermInput: state.searchTerm)
        //set the waiting time limit at 0.5 sec when the value changes
        self.state.searchTerm.debounce(for: 0.5, scheduler: RunLoop.main)
        .removeDuplicates()
        .sink(receiveCompletion: {_ in}) { (searchTerm) in
            self.trigger(.newSearch)
        }.store(in: &cancellableSet)
    }
    
    func loadCharacters(searchTermInput: CurrentValueSubject<String, Never>) {
        do {
            MarvelAPI.characters(page: self.state.page, searchTerm: searchTermInput.value).sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.state.changeViewModelState(newViewModelState: .error(error))
                    switch error {
                    case .serverError(code: let code, message: let reason):
                        print("Server error: \(code), reason: \(reason)")
                    case .decodingError:
                        print("Decoding error \(error)")
                    case .internalError:
                        print("Internal error \(error)")
                    }
                default: break
                }
            }) { (charactersResponse) in
                            if let results = charactersResponse.data?.results {
                                self.state.changeViewModelState(newViewModelState: .loaded)
                                print("Characters: \(results)")
                                if self.state.page > 0 && !self.state.characters.elementsEqual(results, by: { (character, result) -> Bool in
                                    character.id==result.id
                                }) {
                                    var addedCharacters = Array(self.state.characters)
                                    addedCharacters.append(contentsOf: results)
                                    self.state = CharactersListState(characters: addedCharacters, dataState: .loaded, page: self.state.page, searchTerm: searchTermInput)
                                } else {
                                    self.state = CharactersListState(characters: results, dataState: .loaded, page: self.state.page, searchTerm: searchTermInput)
                                }
                            }
                        }
            .store(in: &cancellableSet)
        }
    }
    
    func trigger(_ input: CharacterListInput) {
        switch input {
        case .reloadPage:
            self.loadCharacters(searchTermInput: self.state.searchTerm)
        case .nextPage:
            self.state.changePage(newPageNumber: self.state.page + 1)
        case .newSearch:
            self.state.changePage(newPageNumber: 0)
            self.loadCharacters(searchTermInput: self.state.searchTerm)
        }
    }
    
    deinit {
        cancellableSet.removeAll()
    }
    
}
