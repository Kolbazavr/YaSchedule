//
//  CarrierService.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 28.09.2025.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

typealias CarrierInfo = Components.Schemas.CarrierResponse

protocol CarrierServiceProtocol {
    func getCarrier(with code: String, in codingSystem: String?) async throws -> CarrierInfo
}

final class CarrierService: CarrierServiceProtocol {
    private let client: APIProtocol
    
    init(client: APIProtocol) {
        self.client = client
    }
    
    func getCarrier(with code: String, in codingSystem: String?) async throws -> CarrierInfo {
        let response = try await client.getCarrierInfo(
            query: .init(code: code,system: codingSystem)
        )
        return try response.ok.body.json
    }
}
