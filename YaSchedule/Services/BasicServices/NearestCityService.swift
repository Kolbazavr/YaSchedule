//
//  NearestCityService.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 28.09.2025.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias NearestCity = Components.Schemas.NearestCityResponse

protocol NearestCityServiceProtocol {
    func getNearestCity(lat: Double, lng: Double, distance: Int?) async throws -> NearestCity
}

final class NearestCityService: NearestCityServiceProtocol {
    private let client: APIProtocol
    
    init(client: APIProtocol) {
        self.client = client
    }
    
    func getNearestCity(lat: Double, lng: Double, distance: Int?) async throws -> NearestCity {
        let response = try await client.getNearestCity(
            query: .init(lat: lat, lng: lng, distance: distance)
        )
        return try response.ok.body.json
    }
}
