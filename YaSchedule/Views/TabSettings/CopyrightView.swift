//
//  CopyrightView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 23.10.2025.
//

import SwiftUI

struct CopyrightView: View {
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Color.ypCopyrightBlack.edgesIgnoringSafeArea(.all)
            if let url = URL(string: "https://yandex.ru/legal/practicum_offer/ru/") {
                WebView(
                    isLoading: $isLoading,
                    url: url
                )
                ProgressView("Loading...").opacity(isLoading ? 1 : 0)
            }
        }
        .navigationTitle(Text("Пользовательское соглашение"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CopyrightView()
}
