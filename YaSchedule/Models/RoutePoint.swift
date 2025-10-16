//
//  RoutePoint.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 16.10.2025.
//

import Foundation

struct RoutePoint: Identifiable, Hashable {
    var id: UUID = .init()
    var city: Components.Schemas.Settlement?
    var station: Components.Schemas.Station?
    
    var description: String? {
        guard var routeDescription = city?.title else { return nil }
        if let stationDescription = station?.title {
            routeDescription += " (\(stationDescription))"
        }
        return routeDescription
    }
}
