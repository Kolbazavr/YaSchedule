//
//  MainSearchView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import SwiftUI

struct MainSearchView: View {
    @EnvironmentObject private var viewModel: AppViewModel
    
    var body: some View {
        if let error = viewModel.loadingError {
            ErrorView(error: error)
                .withDefaultBackground()
        } else {
            VStack(spacing: 44) {
                StoriesListView()
                WaypointSelectorView()
                Spacer()
            }
        }
    }
}

#Preview {
    let client = MockClient()
    let cityStationsProvider = CityStationsProvider(client: client)
    let routesProvider = RoutesProvider(client: client)
    MainSearchView()
        .environmentObject(AppViewModel(cityStationsProvider: cityStationsProvider, routesProvider: routesProvider))
}
