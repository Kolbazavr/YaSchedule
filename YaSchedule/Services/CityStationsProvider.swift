//
//  CityStationsProvider.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import Foundation

enum CityStationsProviderError: Error {
    case allStationsParseError
}

final class CityStationsProvider {
    typealias Settlement = Components.Schemas.Settlement
    let allStationsService: StationsListService
    
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
        return settlementsWithTrains
    }
    
    init(client: APIProtocol) {
        self.allStationsService = StationsListService(client: client)
    }
}
