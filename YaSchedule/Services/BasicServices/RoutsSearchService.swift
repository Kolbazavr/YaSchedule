//
//  RoutsSearchService.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 28.09.2025.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias AllSegments = Components.Schemas.Segments

protocol RoutsSearchServiceProtocol {
    func getRouts(from startStationCode: String, to endStationCode: String, on date: Date?, transportTypes: [String]?, offset: Int?, limit: Int?) async throws -> AllSegments
}

final class RoutsSearchService: RoutsSearchServiceProtocol {
    private let client: APIProtocol
    
    init(client: APIProtocol) {
        self.client = client
    }
    
    func getRouts(from startStationCode: String, to endStationCode: String, on date: Date? = nil, transportTypes: [String]? = ["train"], offset: Int? = nil, limit: Int? = nil) async throws -> AllSegments {
        let response = try await client.getScheduleBetweenStations(
            query: .init(
                from: startStationCode,
                to: endStationCode,
                date: date?.toString(),
                transport_types: nil,
                offset: offset,
                limit: limit,
                transfers: nil
            )
        )
        return try response.ok.body.json
    }
}
