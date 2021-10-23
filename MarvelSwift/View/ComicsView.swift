//
//  ComicsView.swift
//  MarvelSwift
//
//  Created by Harshvardhan Basava on 23/10/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ComicsView: View {
    @EnvironmentObject var homeData: HomeViewModel
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false){
                if homeData.fetchedComics.isEmpty{
                    ProgressView()
                        .padding(.top, 20)
                } else{
                    VStack(spacing: 15){
                        ForEach(homeData.fetchedComics){ comic in
                            ComicRowView(comic: comic)
                        }
                    }
                }
            }
            .navigationTitle("Comics")
        }
        .onAppear(perform: {
            if homeData.fetchedComics.isEmpty{
                homeData.fetchComics()
            }
        })
    }
}

struct ComicsView_Previews: PreviewProvider {
    static var previews: some View {
        ComicsView()
    }
}

struct ComicRowView: View{
    var comic: Comics
    var body: some View{
        HStack(alignment: .top, spacing: 15){
            WebImage(url: extractImage(data: comic.thumbnail))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150, alignment: .center)
                .clipped()
            VStack(alignment: .leading, spacing: 8){
                Text(comic.title)
                    .font(.title3)
                    .fontWeight(.bold)
                if let description = comic.description{
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                }
                HStack(spacing: 10){
                    ForEach(comic.urls, id: \.self){ data in
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
