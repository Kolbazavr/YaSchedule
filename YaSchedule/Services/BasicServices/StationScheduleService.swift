//
//  StationScheduleService.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 28.09.2025.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias Schedule = Components.Schemas.ScheduleResponse

protocol StationScheduleServiceProtocol {
    func getSchedule(of station: String) async throws -> Schedule
}

final class StationScheduleService: StationScheduleServiceProtocol {
    private let client: APIProtocol
    
    init(client: APIProtocol) {
        self.client = client
    }
    
    func getSchedule(of station: String) async throws -> Schedule {
        let response = try await client.getStationSchedule(
            query: .init(station: station)
        )
        return try response.ok.body.json
    }
}
