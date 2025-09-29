//
//  RoutsSearchService.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 28.09.2025.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias Routs = Components.Schemas.Segments

protocol RoutsSearchServiceProtocol {
    func getRouts(from startStationCode: String, to endStationCode: String) async throws -> Routs
}

final class RoutsSearchService: RoutsSearchServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getRouts(from startStationCode: String, to endStationCode: String) async throws -> Routs {
        let response = try await client.getScheduleBetweenStations(
            query: .init(
                apikey: apikey,
                from: startStationCode,
                to: endStationCode
            )
        )
        return try response.ok.body.json
    }
}
