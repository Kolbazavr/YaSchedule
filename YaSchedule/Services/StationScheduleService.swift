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
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getSchedule(of station: String) async throws -> Schedule {
        let response = try await client.getStationSchedule(
            query: .init(
                apikey: apikey,
                station: station
            )
        )
        return try response.ok.body.json
    }
}
