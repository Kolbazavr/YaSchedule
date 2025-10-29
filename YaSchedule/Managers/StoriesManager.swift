//
//  StoriesManager.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 24.10.2025.
//

import Foundation
import Combine

final class StoriesManager: ObservableObject {
    
    @Published var stories: [Story] = []
    @Published var selectedStory: Story?
    @Published var storyProgress: CGFloat = 0
    @Published var storySegmentIndex: Int = 0
    
    private var timer: AnyCancellable?
    
    init() { loadStories() }
    
    deinit { stopTimer() }
    
    func select(segmentIndex: Int, in story: Story) {
        storyProgress = 0
        guard let storyIndex = stories.firstIndex(of: story) else { return }
        stories[storyIndex].lastViewedIndex = max(segmentIndex, stories[storyIndex].lastViewedIndex ?? 0)
        storySegmentIndex = segmentIndex
        selectedStory = stories[storyIndex]
    }
 
    func showStory(_ story: Story) {
        select(segmentIndex: 0, in: story)
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                storyProgress >= 1 ? nextSegment() : incrementProgress()
            }
    }
    
    func storySegmentsProgress() -> [CGFloat] {
        selectedStory?.imageNames.indices.map { $0 == storySegmentIndex ? storyProgress : ($0 < storySegmentIndex ? 1 : 0) } ?? []
    }
    
    func hideStory() {
        storySegmentIndex = 0
        selectedStory = nil
        stopTimer()
    }
    
    func nextSegment() {
        guard let selectedStory else { return }
        let nextIndex = (storySegmentIndex + 1) % selectedStory.imageNames.count
        nextIndex == 0 ? next(selectedStory) : select(segmentIndex: nextIndex, in: selectedStory)
    }
    
    func prevSegment() {
        guard let selectedStory else { return }
        let prevIndex = storySegmentIndex - 1
        prevIndex < 0 ? prev(selectedStory) : select(segmentIndex: prevIndex, in: selectedStory)
    }
    
    private func next(_ story: Story) {
        guard let index = stories.firstIndex(of: story) else { return }
        let indexToMove = (index + 1) % stories.count
        select(segmentIndex: 0, in: stories[indexToMove])
    }
    
    private func prev(_ story: Story) {
        guard let index = stories.firstIndex(of: story) else { return }
        let indexToMove = (index - 1 + stories.count) % stories.count
        select(segmentIndex: 0, in: stories[indexToMove])
    }
    
    private func loadStories(from fileName: String = "DummyStories") {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: url)
            let storiesData = try JSONDecoder().decode([StoryData].self, from: data)
            stories = storiesData.map { Story(storyData: $0) }
        } catch {
            print("Decoding error: \(error)")
        }
    }
    
    private func incrementProgress() {
        storyProgress = min(storyProgress + 0.01, 1)
    }
    
    private func stopTimer() {
        storyProgress = 0
        timer?.cancel()
        timer = nil
    }
}
