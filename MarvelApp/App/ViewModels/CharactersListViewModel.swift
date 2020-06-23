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

enum ViewModelState: Equatable {
    static func == (lhs: ViewModelState, rhs: ViewModelState) -> Bool {
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
    var characters: [Character]
    var viewModelState: ViewModelState
    
    mutating func addNewCharacters(addNewCharacters: [Character]) {
        characters.append(contentsOf: addNewCharacters)
    }
    
    mutating func changeViewModelState(newViewModelState: ViewModelState) {
        viewModelState = newViewModelState
    }
}

enum CharacterListInput {
    case reloadPage
}

class CharactersListViewModel: ViewModel {
    
    private var cancellableSet: Set<AnyCancellable> = []
    var page: Int = 0
    
    @Published
    var state: CharactersListState = CharactersListState(characters: [], viewModelState: .loading)
    
    @Published var searchText : String = ""

    init() {
        loadCharacters(searchTerm: searchText)
        //set the waiting time limit at 1 sec when the value changes
        $searchText.debounce(for: 1, scheduler: RunLoop.main)
        .removeDuplicates()
        .sink(receiveCompletion: {_ in}) { (searchTerm) in
            self.page = 0
            self.trigger(.reloadPage)
        }.store(in: &cancellableSet)
    }
    
    func loadCharacters(searchTerm: String = "") {
        do {
            MarvelAPI.characters(page: self.page, searchTerm: searchTerm).sink(receiveCompletion: { completion in
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
                                if self.page > 0 && !self.state.characters.elementsEqual(results, by: { (character, result) -> Bool in
                                    character.id==result.id
                                }) {
                                    self.state.addNewCharacters(addNewCharacters: results)
                                } else {
                                    
                                    self.state = CharactersListState(characters: results, viewModelState: .loaded)
                                }
                            }
                        }
            .store(in: &cancellableSet)
        }
    }
    
    func trigger(_ input: CharacterListInput) {
        switch input {
        case .reloadPage:
            self.loadCharacters(searchTerm: self.searchText)
        }
    }
    
    deinit {
        cancellableSet.removeAll()
    }
    
}
