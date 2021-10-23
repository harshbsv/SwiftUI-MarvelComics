//
//  HomeView.swift
//  MarvelSwift
//
//  Created by Harshvardhan Basava on 23/10/21.
//

import SwiftUI

struct HomeView: View {
    @StateObject var homeData = HomeViewModel()
    var body: some View {
        TabView{
            CharacterView()
                .tabItem({
                    Image(systemName: "person.3.fill")
                    Text("Characters")
                })
//            setting environment object to access data in CharacterView.
                .environmentObject(homeData)
            ComicsView()
                .tabItem({
                    Image(systemName: "books.vertical.fill")
                    Text("Comics")
                })
//            setting environment object to access data in ComicsView.
                .environmentObject(homeData)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
