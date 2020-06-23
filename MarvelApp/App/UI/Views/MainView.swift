//
//  ContentView.swift
//  test
//
//  Created by Ignacio Acisclo on 16/04/2020.
//   
//

import SwiftUI

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()

struct MainView: View {
    
    var body: some View {
        NavigationView {
            CharacterListView().navigationBarTitle(Text("Characters"))
            DetailCharacterView()
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
