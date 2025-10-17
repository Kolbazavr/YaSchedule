//
//  AppView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import SwiftUI

struct AppView: View {
    @EnvironmentObject private var navigationVM: NavigationViewModel
    
    var body: some View {
        NavigationStack(path: $navigationVM.path) {
            TabView {
                MainSearchView()
                    .tabItem {
                        Image(systemName: "arrow.up.message.fill")
                    }
                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                    }
            }
            .tint(.black)
            .navigationDestination(for: NavigationViewModel.NavDestination.self) { viewToShow in
                switch viewToShow {
                      
                case .locationList(routePointIndex: let routePointIndex, routeLocationIndex: let locationIndex):
                    StationListView(waypointIndex: routePointIndex, locationIndex: locationIndex)
                        .withCustomBackButton(waypointIndex: routePointIndex)

                case .carrierList:
                    Text("CarrierListView")
                case .searchFilters:
                    Text("FiltersView")
                case .carrierDetails:
                    Text("CarrierDetailsView")
                }
            }
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
