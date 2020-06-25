//
//  DetailView.swift
//  MarvelApp
//
// 21/04/2020.
//   
//

import SwiftUI

struct DetailCharacterView: View {
    var character: Character?
    @Environment(\.imageCache) var cache: ImageCache
    
    init(result: Character? = nil) {
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont.boldSystemFont(ofSize: 30)]
        self.character = result
    }
    
    var body: some View {
        GeometryReader{ viewGeometry in
            VStack {
                    ScrollView(.horizontal, showsIndicators: false){
                        GeometryReader{ imageGeometry in
                            AsyncImage(
                                url: self.character?.thumbnailUrl(),
                                cache: self.cache,
                                placeholder: LoadingView()
                            )
                            .frame(width: 300, height: 300)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .padding(15)
                                .rotation3DEffect(.degrees(Double(imageGeometry.frame(in: .global).midX - viewGeometry.frame(in: .global).midX)) + Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
                        }
                    }.frame(height:340)
                
                    Text(self.character?.description ?? "").padding(5)
                    
                
                    if (self.character?.comics?.items?.count ?? 0 > 0) {
                        List {
                            Section(header: Text("Comics")) {
                                ForEach(self.character?.comics?.items ?? [], id: \.id)  {
                                    comic in
                                    Text(comic.name ?? "")
                                }
                            }
                        }
                    }
                
            }.navigationBarTitle(Text(self.character?.name ?? ""))
        }
        
    }
}
