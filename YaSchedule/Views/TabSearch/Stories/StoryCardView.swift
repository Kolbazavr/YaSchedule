//
//  StoryCardView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import SwiftUI

struct StoryCardView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(.ypBlue)
            .frame(width: 92)
    }
}

#Preview {
    StoryCardView()
}
