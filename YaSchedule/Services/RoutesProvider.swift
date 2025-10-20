//
//  RoutesProvider.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import Foundation

final class RoutesProvider {
    typealias Segment = Components.Schemas.Segment
    private let routsSearchService: RoutsSearchService
    private let resultsLimit = 20
    
    func getSegments(from originCode: String, to destinationCode: String, limit: Int? = nil, offset: Int? = nil) async throws -> [Segment] {
        let allSegments = try await routsSearchService.getRouts(from: originCode, to: destinationCode, on: Date(), offset: offset, limit: resultsLimit)
        let segments = allSegments.segments
        return segments ?? []
    }
    
    init(client: APIProtocol) {
        self.routsSearchService = RoutsSearchService(client: client)
    }
}
