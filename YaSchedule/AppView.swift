//
//  AppView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import SwiftUI

struct AppView: View {
    @EnvironmentObject private var navigationVM: NavigationViewModel
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppColors.background.color)
        appearance.shadowColor = .black.withAlphaComponent(0.3)
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationStack(path: $navigationVM.path) {
            TabView {
                MainSearchView()
                    .withDefaultBackground()
                    .tabItem {
                        Image(.icSchedule).renderingMode(.template)
                    }
                SettingsView()
                    .withDefaultBackground()
                    .tabItem {
                        Image(.icSettings).renderingMode(.template)
                    }
            }
            .tint(.ypBlack)
            .navigationDestination(for: NavigationViewModel.NavDestination.self) { viewToShow in
                destinationView(viewToShow)
                    .withDefaultBackground()
                    .withCustomBackButton()
            }
        }
    }
    
    @ViewBuilder
    func destinationView(_ destination: NavigationViewModel.NavDestination) -> some View {
        switch destination {
        case .locationList(routePointIndex: let routePointIndex, routeLocationIndex: let locationIndex):
            StationListView(waypointIndex: routePointIndex, locationIndex: locationIndex)
        case .carrierList:
            CarrierListView()
        case .searchFilters:
            FiltersView()
        case .carrierDetails(carrierYaCode: let yaCode):
            CarrierDetailsView(carrierYaCode: yaCode)
        }
    }
        
}

#Preview {
    let client = MockClient()
    let cityStationsProvider = CityStationsProvider(client: client)
    let routesProvider = RoutesProvider(client: client)
    AppView()
        .environmentObject(NavigationViewModel())
        .environmentObject(AppViewModel(cityStationsProvider: cityStationsProvider, routesProvider: routesProvider))
}
