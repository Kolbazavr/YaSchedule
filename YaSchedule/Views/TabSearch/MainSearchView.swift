//
//  MainSearchView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import SwiftUI

struct MainSearchView: View {
    
    var body: some View {
        VStack(spacing: 44) {
            StoriesListView()
            WaypointSelectorView()
            Spacer()
        }
    }
}

#Preview {
    MainSearchView()
}
