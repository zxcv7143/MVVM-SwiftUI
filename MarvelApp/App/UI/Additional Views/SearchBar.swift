//
//  SearchBar.swift
//  MarvelApp
//
//  Created by Anton Zuev on 29/04/2020.
//   
//

import SwiftUI
import Combine

struct SearchBar: UIViewRepresentable {

    var input: CurrentValueSubject<String, Never>
    var placeholder: String

    class Coordinator: NSObject, UISearchBarDelegate {

       var inputStream: CurrentValueSubject<String, Never>
        
        init(input: CurrentValueSubject<String, Never>) {
            self.inputStream = input
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            inputStream.send(searchText)
            // if it´s empty hide the keyboard
//            if searchText.count == 0 {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    searchBar.resignFirstResponder()
//                }
//            }
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
        
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(input: self.input)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        searchBar.searchTextField.enablesReturnKeyAutomatically = false
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = self.input.value
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
