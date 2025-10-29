//
//  UserAgreementWebView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 28.10.2025.
//

import Foundation

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isLoading: Bool
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        
        setThemeCookie(webView: webView, theme: colorScheme == .dark ? "dark" : "light")
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if webView.url != url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func setThemeCookie(webView: WKWebView, theme: String = "light") {
        guard let cookie = HTTPCookie(properties: [
            .domain: ".yandex.ru",
            .path: "/",
            .name: "documentation_theme",
            .value: theme,
            .secure: "TRUE",
            .expires: NSDate(timeIntervalSinceNow: 31536000) // 1 year for unknown reason
        ]) else { return }
        
        webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
            print("Error: \(error.localizedDescription)")
        }
    }
}
