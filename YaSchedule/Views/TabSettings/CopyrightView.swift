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
                WebView(
                    isLoading: $isLoading,
                    url: URL(string: "https://yandex.ru/legal/practicum_offer/ru/")!  
                )
                if isLoading {
                    ProgressView("Loading...")
                }
            }
        .navigationTitle(Text("Пользовательское соглашение"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CopyrightView()
}
