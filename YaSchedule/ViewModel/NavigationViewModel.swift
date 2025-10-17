//
//  NavigationViewModel.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import SwiftUI

class NavigationViewModel: ObservableObject {
//    @Published var selectedTab: Int = 0
    @Published var path = NavigationPath()
    
    enum NavDestination: Hashable {
        case locationList(routePointIndex: Int, routeLocationIndex: Int)
        case carrierList
        case searchFilters
        case carrierDetails
    }
    
    func navigate(to destination: NavDestination) {
        path.append(destination)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func navigateToSelectedLocation(for routePoint: RoutePoint, with index: Int) {
        let locations = routePoint.routeLocations
        for locationIndex in locations.isEmpty ? 0..<1 : locations.indices {
            navigate(to: .locationList(routePointIndex: index, routeLocationIndex: locationIndex))
        }
    }
    
    func navigateToMain() {
        path.removeLast(path.count)
    }
    
}
