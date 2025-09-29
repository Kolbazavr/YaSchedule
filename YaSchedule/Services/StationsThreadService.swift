//
//  StationsThreadService.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 28.09.2025.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias StationsThread = Components.Schemas.ThreadStationsResponse

protocol StationsThreadServiceProtocol {
    func getStationsThread(threadUid: String) async throws -> StationsThread
}

final class StationsThreadService: StationsThreadServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getStationsThread(threadUid: String) async throws -> StationsThread {
        let response = try await client.getRouteStations(query: .init(apikey: apikey, uid: threadUid))
        return try response.ok.body.json
    }
}
