//
//  CharacterView.swift
//  MarvelSwift
//
//  Created by Harshvardhan Basava on 23/10/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CharacterView: View {
    @EnvironmentObject var homeData: HomeViewModel
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 15){
                    HStack(spacing: 10){
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search Character", text: $homeData.searchQuery)
                            .foregroundColor(.black)
                            .accentColor(Color.gray)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(colorScheme == .light ? Color.white : Color.black)
                    .cornerRadius(12)
                    .shadow(color: colorScheme == .light ? Color.gray.opacity(0.06) : Color.white.opacity(0.06), radius: 5, x: 5, y: 5)
                    .shadow(color: colorScheme == .light ? Color.black.opacity(0.06) : Color.white.opacity(0.06), radius: 5, x: -5, y: -5)
                }
                .padding()
                if let characters = homeData.fetchedCharacters{
                    if characters.isEmpty{
                        //no results
                        Text("No results found")
                            .padding(.top, 20)
                    }else{
                        //Display character data
                        ForEach(characters){ character in
                            CharacterRowView(character: character)
                        }
                    }
                } else {
                    if homeData.searchQuery != ""{
                        ProgressView()
                            .padding(.top, 20)
                    }
                }
            }
            .navigationTitle("Marvel")
        }
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.light)
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}

struct CharacterRowView: View{
    var character: Character
    var body: some View{
        HStack(alignment: .top, spacing: 15){
            WebImage(url: extractImage(data: character.thumbnail))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150, alignment: .center)
                .clipped()
            VStack(alignment: .leading, spacing: 8){
                Text(character.name)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(character.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                HStack(spacing: 10){
                    ForEach(character.urls, id: \.self){ data in
                        NavigationLink(destination: WebView(url: extractURL(data: data)).navigationTitle(extractURLType(data: data)), label: {
                            Text(extractURLType(data: data))
                        })
                    }
                }
            }
            Spacer(minLength: 0)
        }
    }
    
    func extractImage(data: [String: String]) -> URL{
        //combining both path and extention to make a URL to pass into the WebImage.
        let path = data["path"] ?? ""
        let ext = data["extension"] ?? ""
        return URL(string: "\(path).\(ext)")!
    }
    
    func extractURL(data: [String: String]) -> URL{
        let url = data["url"] ?? ""
        return URL(string: url)!
    }
    
    func extractURLType(data: [String: String]) -> String{
        let type = data["type"] ?? ""
        return type.capitalized
    }
}
