//
//  AppViewModel.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 14.10.2025.
//

import Foundation

protocol Waypoint: CustomStringConvertible, Hashable {
    var yandexCode: String { get }
}

@MainActor
final class AppViewModel: ObservableObject {
    @Published var route: [RoutePoint] = [.init(), .init()]
    @Published var allSettlements: [Components.Schemas.Settlement] = []
    @Published var segments: [Components.Schemas.Segment] = []
    
    @Published var isLoadingSettlements: Bool = false
    @Published var searchText: String = ""
    @Published var loadingError: Error?
    
    private let cityStationsProvider: CityStationsProvider
    private let routesProvider: RoutesProvider
    
    enum FilterOption {
        case morning, afternoon, evening, night
    }
    
    init(cityStationsProvider: CityStationsProvider, routesProvider: RoutesProvider) {
        self.cityStationsProvider = cityStationsProvider
        self.routesProvider = routesProvider
        loadSettlements()
    }
    
    func loadSettlements() {
        Task {
            do {
                allSettlements = try await cityStationsProvider.getSettlements()
            } catch {
                print("Error loading all settlements: \(error)")
                loadingError = error
            }
        }
    }
    
    func isReadyToSearch() -> Bool {
        route[0].city != nil && route[1].city != nil
    }
    
    func filteredWaypoints(for waypointIndex: Int) -> [any Waypoint] {
        let waypoint = route[waypointIndex]
        if let selectedCity = waypoint.city {
            return selectedCity.stations?.filter { station in
                searchText.isEmpty || station.title?.lowercased().contains(searchText.lowercased()) ?? false
            } ?? []
        } else {
            return allSettlements.filter { settlement in
                searchText.isEmpty || settlement.title?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
    }
    
    func addItem(_ item: any Waypoint, to routePointWithIndex: Int) -> Bool {
        var updatedPoint = route[routePointWithIndex]
        var isFinishedAdding: Bool = false
        
        switch item {
        case let city as Components.Schemas.Settlement:
            updatedPoint.city = city
        case let station as Components.Schemas.Station:
            updatedPoint.station = station
            isFinishedAdding = true
        default:
            print(#function, "Unsupported item: \(item)")
            break
        }
        
        route[routePointWithIndex] = updatedPoint
        
        return isFinishedAdding
    }
    
    func backButtonTapped(with waypointIndex: Int) -> Bool {
        let shouldGoToMainScreen: Bool = true
        guard route[waypointIndex].station != nil else { return shouldGoToMainScreen }
        route[waypointIndex] = .init()
        return !shouldGoToMainScreen
    }
    
    func searchRoutes() {
        
    }
    
    func swapOriginAndDestination() {
        route.reverse()
    }
    
    func filterByDepartureTime(dayParts: [FilterOption]) {
        
    }
    
}
