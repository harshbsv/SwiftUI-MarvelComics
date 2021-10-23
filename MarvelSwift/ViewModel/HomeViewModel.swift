//
//  HomeViewModel.swift
//  MarvelSwift
//
//  Created by Harshvardhan Basava on 23/10/21.
//

import Foundation
import SwiftUI
import Combine
import CryptoKit

class HomeViewModel: ObservableObject{
    @Published var searchQuery = ""
    //Combine framework searh bar
    //used to cancel the search publisher
    var searchCancellable: AnyCancellable? = nil
    //fetched character data
    @Published var fetchedCharacters: [Character]? = nil
    //fetched comic data
    @Published var fetchedComics: [Comics] = []
    @Published var offset: Int = 0
    init(){
        //SwiftUI uses @Published, hence it is a Publisher
        //we dont need to explicitly define a Publisher.
        searchCancellable = $searchQuery
            .removeDuplicates() //remove duplicate entries
        // no need to fetch for every user entry
        // it will wait for 0.6 seconds after user ends typing
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .sink(receiveValue: { str in
                if str == "" {
                    //reset data
                    self.fetchedCharacters = nil
                } else {
                    self.searchCharacter()
                }
            })
    }
    //search the characters
    func searchCharacter(){
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5("\(ts)\(privateKey)\(publicKey)")
        let originalQuery = searchQuery.replacingOccurrences(of: " ", with: "%20")
        let url = "https://gateway.marvel.com:443/v1/public/characters?nameStartsWith=\(originalQuery)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!) { (data, _ , err) in
            if let error = err{
                print(error.localizedDescription)
                return
            }
            guard let APIData = data else{
                print("no data found")
                return
            }
            do{
                //decoding API data
                let characters = try JSONDecoder().decode(APIResult.self, from: APIData)
                DispatchQueue.main.async {
                    if self.fetchedCharacters == nil{
                        self.fetchedCharacters = characters.data.results
                    }
                }
            }catch{
                print(error.localizedDescription)
            }
        }
        .resume()
    }
    //search the comics
    func fetchComics(){
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5("\(ts)\(privateKey)\(publicKey)")
        let url = "https://gateway.marvel.com:443/v1/public/comics?limit=20&offset=\(offset)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            if let error = err{
                print(error.localizedDescription)
                return
            }
            guard let APIComicsData = data else{
                print("no data found")
                return
            }
            do{
                let comics = try JSONDecoder().decode(APIComicResult.self, from: APIComicsData)
                DispatchQueue.main.async{
                    self.fetchedComics = comics.data.results                }
            } catch {
                print(error.localizedDescription)
            }
        }
        .resume()
    }
    
    //MD5 Hash generator
    func MD5(_ hash: String) -> String{
        let hash = Insecure.MD5.hash(data: hash.data(using: .utf8) ?? Data())
        return hash.map{
            String(format: "%02hhx", $0)
        }
        .joined()
    }
}
