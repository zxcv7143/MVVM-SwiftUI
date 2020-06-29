//
//  MasterView.swift
//  MarvelApp
//
// 21/04/2020.
//   
//

import SwiftUI

struct CharacterListView: View {
    @EnvironmentObject
    var viewModel: AnyViewModel<CharactersListState, CharacterListInput>
    
    
    var body: some View {
        VStack() {
            SearchBar(input: viewModel.searchTerm, placeholder: "Search characters")
            content
        }
    }
    
    private var content: some View {
        switch viewModel.state.viewModelState {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return LoadingView().frame(maxHeight: .infinity).eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .loaded:
            return self.characterList(characters: self.viewModel.state.characters).eraseToAnyView()
        }
    }
    
    private func characterList(characters: [Character]) -> some View {
        List {
            ForEach(characters, id: \.id) { character in
                NavigationLink(
                    destination: DetailCharacterView(result: character)
                ) {
                        VStack(spacing: 10) {
                            Text("\(character.name ?? "")").frame(maxWidth: .infinity, alignment: Alignment.leading)
                            if self.viewModel.state.viewModelState == .loaded && self.viewModel.state.characters.isLastItem(character) {
                                Divider()
                                LoadingView()
                            }
                        }.onAppear {
                            self.listItemAppears(character)
                        }
                }
            }
        }
    }
}

extension CharacterListView {
    
    private func listItemAppears<Item: Identifiable>(_ item: Item) {
        if self.viewModel.state.characters.isThresholdItem(offset: 5, item: item)  {
            self.viewModel.trigger(.nextPage)
            self.viewModel.trigger(.reloadPage)
        }
    }
}
