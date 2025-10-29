//
//  FullScreenStoryView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 24.10.2025.
//

import SwiftUI

struct FullScreenStoryView: View {
    @EnvironmentObject var storiesManager: StoriesManager
    @EnvironmentObject var namespaceWrapper: NamespaceWrapper
    
    @State private var isTextExpanded: Bool = false
    
    let story: Story
    
    var body: some View {
        ZStack {
            Color.ypBlackUni.ignoresSafeArea(edges: .all)
            
            Image(story.imageNames[storiesManager.storySegmentIndex])
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
                .matchedGeometryEffect(id: story.id, in: namespaceWrapper.namespace, isSource: storiesManager.selectedStory == nil ? false : true)
                .animation(.spring, value: story)
            
            SwipeControlView(
                swipeUpAction: {},
                swipeDownAction: storiesManager.hideStory,
                swipeLeftAction: storiesManager.nextSegment,
                swipeRightAction: storiesManager.prevSegment
            )
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    ForEach(0..<storiesManager.storySegmentsProgress().count, id: \.self) { progressBarIndex in
                        ProgressView(value: storiesManager.storySegmentsProgress()[progressBarIndex], total: 1)
                            .progressViewStyle(YaProgressBar())
                    }
                }
                .allowsHitTesting(false)
                
                HStack {
                    Spacer()
                    Button {
                        withAnimation { storiesManager.hideStory() }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(.ypWhiteUni, .ypBlackUni)
                    }
                }
                
                Spacer()
                
                Text(storiesManager.selectedStory?.title ?? "Title Text")
                    .lineLimit(isTextExpanded ? 5 : 2)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.ypWhiteUni)
                    .allowsHitTesting(false)
                Text(storiesManager.selectedStory?.text ?? "Story text")
                    .lineLimit(isTextExpanded ? 10 : 3)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(.ypWhiteUni)
                    .allowsHitTesting(false)
                
                if storiesManager.selectedStory?.text.count ?? 0 > 110 {
                    Button(isTextExpanded ? "Show less" : "Read more") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isTextExpanded.toggle()
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                } 
            }
            .padding(.top, 28)
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    FullScreenStoryView(story: Story(storyData: .init(title: "Story Title", text: "Story Text Story Text Story Text Story Text Story Text Story Text Story Text Story Text Story Text ", previewName: "Story1Preview", imageNames: ["Story1-1", "Story1-2"])))
    .environmentObject(StoriesManager())
    .environmentObject(NamespaceWrapper(Namespace().wrappedValue))
}
