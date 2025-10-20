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
                .disabled(viewModel.isLoadingSomething)
            ListView(
                items: viewModel.waypointsToSelect(for: waypointIndex, locationIndex: locationIndex),
                wayPointIndex: waypointIndex,
                locationIndex: locationIndex
            )
            .overlay {
                if viewModel.isLoadingSomething {
                    ProgressView("Loading...")
                } else if viewModel.waypointsToSelect(for: waypointIndex, locationIndex: locationIndex).isEmpty {
                    Text(locationIndex == 0 ? "Город не найден" : "Станция не найдена")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.ypBlack)
                }
            }
        }
        .navigationTitle(Text(locationIndex == 0 ? "Выбор города" : "Выбор станции"))
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
