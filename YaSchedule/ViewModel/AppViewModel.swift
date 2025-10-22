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

enum AppViewModelError: Error {
    case waypointsNotFound
}

@MainActor
final class AppViewModel: ObservableObject {
    @Published var route: [RoutePoint] = [.init(), .init()]
    @Published var allSettlements: [Components.Schemas.Settlement] = []
    @Published var segments: [Components.Schemas.Segment] = []
    
    @Published var isLoadingSomething: Bool = true
    @Published var searchText: String = ""
    @Published var loadingError: Error?
    @Published var foundNothing: Bool = false
    
    @Published var isTransfersAllowed: Bool = true
    @Published var selectedDayPeriods: Set<DayPeriod> = []

    private let cityStationsProvider: CityStationsProvider
    private let routesProvider: RoutesProvider
    private let searchResultsLimit = 20
    private let totalSegmentsLimit = 99
    
    init(cityStationsProvider: CityStationsProvider, routesProvider: RoutesProvider) {
        self.cityStationsProvider = cityStationsProvider
        self.routesProvider = routesProvider
        loadSettlements()
    }
    
    func isReadyToSearch() -> Bool {
        route[0].routeWaypoints.count > 0 && route[1].routeWaypoints.count > 0
    }
    
    func waypointsToSelect(for waypointIndex: Int, locationIndex: Int?) -> [any Waypoint] {
        guard let locationIndex, locationIndex > 0 else {
            return allSettlements.filterBy(title: searchText)
        }
        let selectedSettlement = route[waypointIndex].routeWaypoints.first as? Components.Schemas.Settlement
        return selectedSettlement?.stations?.filterBy(title: searchText) ?? []
    }
    
    func addWaypoint(_ waypoint: any Waypoint, to routePointWithIndex: Int) -> Bool {
        var updatedPoint = route[routePointWithIndex]
        
        switch waypoint {
        case let city as Components.Schemas.Settlement:
            updatedPoint.routeWaypoints = [city]
        case let station as Components.Schemas.Station:
            updatedPoint.routeWaypoints = [updatedPoint.routeWaypoints[0], station]
        default:
            print(#function, "Unsupported item: \(waypoint)")
            break
        }
        
        assert(updatedPoint.routeWaypoints.count <= 2, "Should not have more than 2 waypoints, current waypoints: \(updatedPoint.routeWaypoints)")
        route[routePointWithIndex] = updatedPoint
        
        return route[routePointWithIndex].routeWaypoints.count == 2
    }
    
    func toggleFilterOption(_ option: DayPeriod) {
        let _ = selectedDayPeriods.remove(option) ?? selectedDayPeriods.insert(option).memberAfterInsert
    }
    
    func filteredSegments() -> [Components.Schemas.Segment] {
        segments.filter { segment in
            let isInSelectedDayPeriod = selectedDayPeriods.isEmpty || selectedDayPeriods.contains { $0 == segment.departureDayPeriod }
            let isWithSelectedTransfers = isTransfersAllowed || segment.has_transfers == false
            
            return isInSelectedDayPeriod && isWithSelectedTransfers
        }
    }
    
    func searchRoutes(_ isNewSearch: Bool = true) {
        if isNewSearch { reset() }
        
        guard isReadyToSearch() else { return }
        guard !isLoadingSomething else { return }
        guard !foundNothing else { return }
        
        isLoadingSomething = true
        loadingError = nil
        
        Task {
            do {
                guard let origin = route[0].routeWaypoints.last,
                      let destination = route[1].routeWaypoints.last
                else { throw AppViewModelError.waypointsNotFound }
                let originCode = origin.yandexCode
                let destinationCode = destination.yandexCode
                let fetchedSegments = try await routesProvider.getSegments(
                    from: originCode,
                    to: destinationCode,
                    limit: searchResultsLimit,
                    offset: segments.count
                )

                if fetchedSegments.isEmpty {
                    foundNothing = true
                } else {
                    segments.append(contentsOf: fetchedSegments)
                }
            } catch {
                print(#function, "Failed to fetch routes: \(error)")
                loadingError = error
                isLoadingSomething = false
            }
            isLoadingSomething = false
            
            if !foundNothing && filteredSegments().isEmpty && segments.count < totalSegmentsLimit {
                searchRoutes()
            }
        }
    }
    
    func swapOriginAndDestination() {
        route.reverse()
    }
    
    private func reset() {
        segments.removeAll()
        isTransfersAllowed = true
        foundNothing = false
        selectedDayPeriods.removeAll()
    }
    
    private func loadSettlements() {
        Task {
            do {
                allSettlements = try await cityStationsProvider.getSettlements()
            } catch {
                print("Error loading all settlements: \(error)")
                loadingError = error
                isLoadingSomething = false
            }
            isLoadingSomething = false
        }
    }
}
