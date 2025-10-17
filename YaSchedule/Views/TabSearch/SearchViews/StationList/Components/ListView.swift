//
//  ItemsListView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 16.10.2025.
//

import SwiftUI

struct ListView: View {
    let items: [any Waypoint]?
    let wayPointIndex: Int
    let locationIndex: Int
    
    var body: some View {
        if let items {
            List() {
                ForEach(items, id: \.hashValue) { item in
                    ItemView(item: item, waypointIndex: wayPointIndex, locationIndex: locationIndex)
                        .frame(height: 60)
                        .foregroundStyle(.ypBlack)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    let item: Components.Schemas.Settlement = .init(title: "Some City or TrainStation", codes: .init(yandex_code: UUID().uuidString), stations: [])
    ListView(items: .init(repeating: item, count: 10), wayPointIndex: 0, locationIndex: 0)
}
