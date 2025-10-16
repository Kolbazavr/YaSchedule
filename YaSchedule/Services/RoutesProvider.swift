//
//  RoutesProvider.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import Foundation

final class RoutesProvider {
    typealias Segment = Components.Schemas.Segment
    let routsSearchService: RoutsSearchService
    let resultsLimit = 20
    
    func getSegments(from originCode: String, to destinationCode: String, limit: Int? = nil, offset: Int? = nil) async throws -> [Segment] {
        let allSegments = try await routsSearchService.getRouts(from: originCode, to: destinationCode, on: Date(), offset: nil, limit: resultsLimit)
        let segments = allSegments.segments
        print("segments count: \(segments?.count)")
        
        segments?.enumerated().forEach({ index, segment in
            print("segment index: \(index), segment arrival: \(segment.arrival), segment departure: \(segment.departure), segment duration: \(segment.duration), from: \(segment.from?.title), to: \(segment.to?.title)")
        })
        
        return segments ?? []
    }
    
    init(client: APIProtocol) {
        self.routsSearchService = RoutsSearchService(client: client)
    }
}
