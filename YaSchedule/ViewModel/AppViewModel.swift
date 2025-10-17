//
//  AppViewModel.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 14.10.2025.
//

import Foundation

protocol Waypoint: CustomStringConvertible, Hashable {
    var title: String? { get }
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
        route[0].routeLocations.count > 0 && route[1].routeLocations.count > 0
    }
    
    func waypointsToSelect(for waypointIndex: Int, locationIndex: Int?) -> [any Waypoint] {
        guard let locationIndex, locationIndex > 0 else {
            return allSettlements.filterBy(title: searchText)
        }
        let selectedSettlement = route[waypointIndex].routeLocations.first as? Components.Schemas.Settlement
        return selectedSettlement?.stations?.filterBy(title: searchText) ?? []
    }
    
    func addItem(_ item: any Waypoint, to routePointWithIndex: Int) -> Bool {
        var updatedPoint = route[routePointWithIndex]
        
        switch item {
        case let city as Components.Schemas.Settlement:
            updatedPoint.routeLocations = [city]
        case let station as Components.Schemas.Station:
            updatedPoint.routeLocations = [updatedPoint.routeLocations[0], station]
        default:
            print(#function, "Unsupported item: \(item)")
            break
        }
        
        assert(updatedPoint.routeLocations.count <= 2, "Should not have more than 2 waypoints, current waypoints: \(updatedPoint.routeLocations)")
        route[routePointWithIndex] = updatedPoint
        
        return route[routePointWithIndex].routeLocations.count == 2
    }
    
    func searchRoutes() {
        
    }
    
    func swapOriginAndDestination() {
        route.reverse()
    }
    
    func filterByDepartureTime(dayParts: [FilterOption]) {
        
    }
    
}
