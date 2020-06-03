//
//  MasterView.swift
//  MarvelApp
//
//  Created by Ignacio Acisclo on 21/04/2020.
//  Copyright © 2020 Ignacio Acisclo. All rights reserved.
//

import SwiftUI

struct MasterView: View {
    @ObservedObject var viewModel: MarvelViewModel = MarvelViewModel()
    
    var body: some View {
        VStack() {
            SearchBar(text: $viewModel.searchText, placeholder: "Search characteres")
            content
        }.onAppear {
            self.viewModel.send(event: .onAppear)
        }
    }
    
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return LoadingView().frame(maxHeight: .infinity).eraseToAnyView()
        case .error(let error):
            return Text(error.localizedDescription).eraseToAnyView()
        case .loadingNewPage:
            return self.characterList(characters: self.viewModel.characters).eraseToAnyView()
        case .loaded(let characters):
            return self.characterList(characters: characters).eraseToAnyView()
        }
    }
    
    private func characterList(characters: [Character]) -> some View {
        List {
            ForEach(characters, id: \.id) { character in
                NavigationLink(
                    destination: DetailView(result: character)
                ) {
                        VStack(spacing: 10) {
                            Text("\(character.name ?? "")").frame(maxWidth: .infinity, alignment: Alignment.leading)
                            if self.viewModel.state == .loadingNewPage && self.viewModel.characters.isLastItem(character) {
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

extension MasterView {
    
    private func listItemAppears<Item: Identifiable>(_ item: Item) {
        if self.viewModel.characters.isThresholdItem(offset: 5, item: item)  {
            self.viewModel.page+=1
            self.viewModel.send(event: .onStartLoadingCharacters)
        }
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView(viewModel: MarvelViewModel())
    }
}
