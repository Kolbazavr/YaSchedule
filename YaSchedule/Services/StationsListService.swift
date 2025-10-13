//
//  StationsListService.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 28.09.2025.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias AllStations = Components.Schemas.AllStationsResponse

protocol StationsListServiceProtocol {
    func getAllStations() async throws -> AllStations
}

final class StationsListService: StationsListServiceProtocol {
    private let client: Client
    private let apikey: String
    private let decoder = JSONDecoder()
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getAllStations() async throws -> AllStations {
        let response = try await client.getAllStations(query: .init(apikey: apikey))
        let responseBody = try response.ok.body.html
        let limit = 50 * 1024 * 1024 // 50Mb
        let fullData = try await Data(collecting: responseBody, upTo: limit)
        
        let allStations = try decoder.decode(AllStations.self, from: fullData)
        
        return allStations
    }
}
