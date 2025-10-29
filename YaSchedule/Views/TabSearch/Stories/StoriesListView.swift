//
//  StoriesListView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import SwiftUI

struct StoriesListView: View {
    @EnvironmentObject private var storiesManager: StoriesManager

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 12) {
                ForEach(storiesManager.stories) { story in
                    StoryCardView(story: story)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.3)) {
                                storiesManager.showStory(story)
                            }
                        }
                }
            }
            .padding(.horizontal, 16)
        }
        .scrollIndicators(.hidden)
        .frame(height: 148)
    }
}

#Preview {
    StoriesListView()
        .environmentObject(StoriesManager())
}
