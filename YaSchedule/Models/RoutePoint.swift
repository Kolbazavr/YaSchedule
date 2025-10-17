//
//  RoutePoint.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 16.10.2025.
//

import Foundation

struct RoutePoint: Identifiable {
    var id: UUID = .init()
    var routeLocations: [any Waypoint] = []
    
    var description: String? {
        var cityName: String?
        var stationName: String?
        
        for case let city in routeLocations where city is Components.Schemas.Settlement {
            cityName = (city as! Components.Schemas.Settlement).title
        }
        
        guard var routeDescription = cityName else { return nil }
        
        for case let station in routeLocations where station is Components.Schemas.Station {
            stationName = (station as! Components.Schemas.Station).title
        }
        
        if let stationName {
            routeDescription += " (\(stationName))"
        }
        
        return routeDescription
    }
}

extension RoutePoint: Hashable, Equatable {
    static func == (lhs: RoutePoint, rhs: RoutePoint) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
