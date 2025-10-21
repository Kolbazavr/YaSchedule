//
//  CityStationsProvider.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import Foundation

enum CityStationsProviderError: Error {
    case allStationsParseError
    case sortingError
}

final class CityStationsProvider {
    typealias Settlement = Components.Schemas.Settlement
    private let allStationsService: StationsListService
    private let priorityCities: [String]
    
    func getSettlements(with transportTypes: String = "train") async throws -> [Settlement] {
        let allStations = try await allStationsService.getAllStations()
        guard let allCountries = allStations.countries,
              let russiaCountry = allCountries.first(where: { $0.title?.lowercased() == "россия" }),
              let russiaRegions = russiaCountry.regions
        else {
            throw CityStationsProviderError.allStationsParseError
        }
        let russiaSettlements = russiaRegions.compactMap { $0.settlements } .flatMap { $0 }
        let settlementsWithTrains: [Settlement] = russiaSettlements.compactMap { settlement in
            guard let settlementTitle = settlement.title,
                  let settlementCodes = settlement.codes,
                  let settlementStations = settlement.stations,
                  let code = settlementCodes.yandex_code,
                  !settlementTitle.isEmpty,
                  !code.isEmpty,
                  !settlementStations.isEmpty
            else { return nil }
            
            let settlementTrainStations = settlementStations.filter { !($0.title ?? "").isEmpty && $0.transport_type == transportTypes }
            guard settlementTrainStations.count > 0 else { return nil }
            return Settlement(title: settlement.title, codes: settlement.codes, stations: settlementTrainStations)
        }
        
        return try sortedSettlements(settlementsWithTrains)
    }
    
    private func sortedSettlements(_ settlements: [Settlement]) throws -> [Settlement] {
        let priorityOrder = Dictionary(uniqueKeysWithValues: priorityCities.enumerated().map { ($1, $0) })
        let sortedSettlements = try settlements.sorted { first, second in
            guard first.title != nil, second.title != nil else {
                print ("Sorting error: one of the settlements has no title, this should be checked before (there 👆)")
                throw CityStationsProviderError.sortingError
            }
            let firstPriorityRank = priorityOrder[first.title!]
            let secondPriorityRank = priorityOrder[second.title!]
            
            return switch (firstPriorityRank, secondPriorityRank) {
            case (let rank1?, let rank2?): rank1 < rank2
            case (_, nil): true
            case (nil, _): false
            }
        }
        return sortedSettlements
    }
    
    
    init(client: APIProtocol, priorityCities: [String] = PriorityCities.all ?? []) {
        self.allStationsService = StationsListService(client: client)
        self.priorityCities = priorityCities
    }
}
