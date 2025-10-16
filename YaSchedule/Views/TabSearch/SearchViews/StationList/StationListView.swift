//
//  StationSearchView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import SwiftUI



struct StationListView: View {
    @EnvironmentObject private var viewModel: AppViewModel
    
    let waypointIndex: Int
    private let textLimit: Int = 20
    
//    var searchResults: [String] {
//        searchText.isEmpty ? cities : cities.filter { $0.lowercased().contains(searchText.lowercased()) }
//    }
    
    var body: some View {
        VStack {
            SearchBarView(searchText: $viewModel.searchText, textLimit: 20)
                .padding(.horizontal, 16)
            
            ListView(items: viewModel.filteredWaypoints(for: waypointIndex), wayPointIndex: waypointIndex)
            

//            if let selectedCity = viewModel.route[waypointIndex].city {
//                ListView(items: selectedCity.stations, wayPointIndex: waypointIndex)
//            } else {
//                ListView(items: viewModel.allSettlements, wayPointIndex: waypointIndex)
//            }
        }
        .navigationTitle(Text("City Search"))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let client = MockClient()
    let cityStationsProvider = CityStationsProvider(client: client)
    let routesProvider = RoutesProvider(client: client)
    StationListView(waypointIndex: 0)
        .environmentObject(AppViewModel(cityStationsProvider: cityStationsProvider, routesProvider: routesProvider))
}
