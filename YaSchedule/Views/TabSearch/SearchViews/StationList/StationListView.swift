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
    let locationIndex: Int
    
    private let textLimit: Int = 20
    
    var body: some View {
        VStack {
            SearchBarView(searchText: $viewModel.searchText, textLimit: 20)
                .padding(.horizontal, 16)
            ListView(
                items: viewModel.waypointsToSelect(for: waypointIndex, locationIndex: locationIndex),
                wayPointIndex: waypointIndex,
                locationIndex: locationIndex
            )
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
    StationListView(waypointIndex: 0, locationIndex: 0)
        .environmentObject(AppViewModel(cityStationsProvider: cityStationsProvider, routesProvider: routesProvider))
}
