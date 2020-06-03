//
//  ContentView.swift
//  test
//
//  Created by Ignacio Acisclo on 16/04/2020.
//  Copyright © 2020 Ignacio Acisclo. All rights reserved.
//

import SwiftUI

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            MasterView().navigationBarTitle(Text("Characters"))
            DetailView()
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
