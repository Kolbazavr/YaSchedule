//
//  StoryCardView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import SwiftUI

struct StoryCardView: View {
    @EnvironmentObject var storiesManager: StoriesManager
    @EnvironmentObject var namespaceWrapper: NamespaceWrapper
    
    let story: Story
    
    var body: some View {
        ZStack {
            Image(story.previewName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .inset(by: 2)
                        .stroke(style: StrokeStyle(lineWidth: 4))
                        .fill(.ypBlue)
                        .opacity(story.isLastImageViewed ? 0 : 1)
                }
                .matchedGeometryEffect(id: story.id, in: namespaceWrapper.namespace, isSource: false)
            VStack {
                Spacer()
                Text(story.title)
                    .lineLimit(3)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.ypWhiteUni)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 12)
            }
        }
        .opacity(story.isLastImageViewed ? 0.5 : 1)
        .frame(width: 92)
    }
}

#Preview {
    StoryCardView(story: Story(storyData: .init(title: "Story Title", text: "Story Text Story Text Story Text Story Text Story Text Story Text Story Text Story Text Story Text ", previewName: "Story1Preview", imageNames: ["Story1-1", "Story1-2"])))
        .environmentObject(NamespaceWrapper(Namespace().wrappedValue))
}
