//
//  WebViewRepresentable.swift
//  VideoPlayerSwiftUI
//
//  Created by Bechir Belkahla on 17/6/2024.
//

import Foundation
import SwiftUI
import WebKit


struct WebViewRepresentable: UIViewRepresentable {
    
    var htmlContent: String
    @Binding var didFinishLoading: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
           var parent: WebViewRepresentable
           
           init(_ parent: WebViewRepresentable) {
               self.parent = parent
           }
           
           func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
               //notifing the view that webView did finish loading the content
               parent.didFinishLoading = true
           }
           
           func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
               if navigationAction.navigationType == .linkActivated {
                   if let url = navigationAction.request.url {
                       UIApplication.shared.open(url)
                       decisionHandler(.cancel)
                       return
                   }
               }
               decisionHandler(.allow)
           }
       }
}
