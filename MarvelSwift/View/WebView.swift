//
//  WebView.swift
//  MarvelSwift
//
//  Created by Harshvardhan Basava on 23/10/21.
//

import SwiftUI
import UIKit
import WebKit

//struct WebView: UIViewRepresentable{
//    var url: URL
//
//    func makeUIView(context: Context) -> some WKWebView {
//        let webview = WKWebView()
//        webview.load(URLRequest(url: url))
//        return webview
//    }
//
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//
//    }
//}

struct WebView : UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView  {
        let webview = WKWebView()
        webview.load(URLRequest(url: url))
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        //uiView.load(url)
    }
}
