//
//  Credentials.swift
//  MarvelSwift
//
//  Created by Harshvardhan Basava on 23/10/21.
//

import SwiftUI

//  Add your own public and private keys here to make API calls.
//  You can generate the hash required for the API call either here
//  in Swift code, or use any online generators.

//  The MD5 hash generator I wrote is in HomeViewModel.swift under ViewModel.

//  The usual pattern for generating a Marvel API hash is (timestamp+privateKey+publicKey).
//  For this project, I have generated timestamp using the Date().timeIntervalSince1970
//  and converted it to a string to use it in the API call.

let privateKey = ""
let publicKey = ""
//let hashKey = ""
