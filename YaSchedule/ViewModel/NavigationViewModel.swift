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
        case citySearch(Int)
        case carrierList
        case searchFilters
        case carrierDetails
    }
    
    func navigate(to destination: NavDestination) {
        path.append(destination)
    }
    
    func navigateToMain() {
        path.removeLast(path.count)
    }
    
}
