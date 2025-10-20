//
//  StoriesListView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import SwiftUI

struct StoriesListView: View {
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 12) {
                StoryCardView()
                StoryCardView()
                StoryCardView()
                StoryCardView()
                StoryCardView()
                StoryCardView()
            }
            
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, 16)
        .frame(height: 148)
    }
}

#Preview {
    StoriesListView()
}
