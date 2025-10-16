//
//  ListItemView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import SwiftUI

struct ItemView: View {
    @EnvironmentObject private var viewModel: AppViewModel
    @EnvironmentObject private var navigationVM: NavigationViewModel
    
    let item: any Waypoint
    let waypointIndex: Int
    
    var body: some View {
        Button {
            let isFinished = viewModel.addItem(item, to: waypointIndex)
            isFinished ? navigationVM.navigateToMain() : navigationVM.navigate(to: .citySearch(waypointIndex))
        } label: {
            HStack {
                Text(item.description)
                    .font(.system(size: 17, weight: .regular))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 24, weight: .regular))
            }
        }
        .tint(.ypBlack)
    }
}

#Preview {
    let item: Components.Schemas.Settlement = .init(title: "Some City or TrainStation", codes: .init(yandex_code: UUID().uuidString), stations: [])
    ItemView(item: item, waypointIndex: 0)
}
