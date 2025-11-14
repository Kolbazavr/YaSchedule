//
//  Story.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 24.10.2025.
//

import Foundation

struct Story: Identifiable {
    let id = UUID()
    let title: String
    let text: String
    let previewName: String
    let imageNames: [String]
    var lastViewedIndex: Int?
    
    var isLastImageViewed: Bool { lastViewedIndex == imageNames.count - 1 }
    
    init(storyData: StoryData) {
        self.title = storyData.title
        self.text = storyData.text
        self.previewName = storyData.previewName
        self.imageNames = storyData.imageNames
    }
}

extension Story: Equatable {
    static func == (lhs: Story, rhs: Story) -> Bool { lhs.id == rhs.id }
}

struct StoryData: Codable {
    let title: String
    let text: String
    let previewName: String
    let imageNames: [String]
}
