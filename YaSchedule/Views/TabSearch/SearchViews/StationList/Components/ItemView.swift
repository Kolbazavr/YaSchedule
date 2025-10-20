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
    let locationIndex: Int
    
    var body: some View {
        Button {
            let isFinished = viewModel.addWaypoint(item, to: waypointIndex)
            isFinished ? navigationVM.navigateToMain() : navigationVM.navigate(to: .locationList(routePointIndex: waypointIndex, routeLocationIndex: 1))
        } label: {
            HStack {
                if isSelected() {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8, weight: .regular))
                        .foregroundStyle(.purple)
                }
                Text(item.description)
                    .font(.system(size: 17, weight: .regular))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 24, weight: .regular))
            }
        }
        .tint(.ypBlack)
    }
    
    func isSelected() -> Bool {
        let routePointLocations = viewModel.route[waypointIndex].routeWaypoints
        let isSomethingSelected = routePointLocations.count > locationIndex
        return isSomethingSelected ? item.title == routePointLocations[locationIndex].title : false
    }
}

#Preview {
    let item: Components.Schemas.Settlement = .init(title: "Some City or TrainStation", codes: .init(yandex_code: UUID().uuidString), stations: [])
    ItemView(item: item, waypointIndex: 0, locationIndex: 0)
}
