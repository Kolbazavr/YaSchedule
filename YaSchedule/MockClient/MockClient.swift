//
//  MockClient.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 13.10.2025.
//

import Foundation
import OpenAPIRuntime

enum MockError: Error {
    case fileNotFound(String)
    case decodingError
}

struct MockClient: APIProtocol {
    func getAllStations(_ input: Operations.getAllStations.Input) async throws -> Operations.getAllStations.Output {
        guard let fileURL = Bundle.main.url(forResource: "AllStationsResponse.html", withExtension: nil) else {
            throw MockError.fileNotFound("AllStationsResponse.html")
        }
        let htmlAllStationsResponse: String = try String(contentsOf: fileURL, encoding: .utf8)
        return .ok(.init(body: .html(.init(htmlAllStationsResponse))))
    }
    
    func getCarrierInfo(_ input: Operations.getCarrierInfo.Input) async throws -> Operations.getCarrierInfo.Output {
        let carrierInfoResponse: Components.Schemas.CarrierResponse = try loadJSONFromFile("CarrierInfoResponse.json")
        return .ok(.init(body: .json(carrierInfoResponse)))
    }
    
    func getNearestCity(_ input: Operations.getNearestCity.Input) async throws -> Operations.getNearestCity.Output {
        let nearestCityResponse: Components.Schemas.NearestCityResponse = try loadJSONFromFile("NearestCityResponse.json")
        return .ok(.init(body: .json(nearestCityResponse)))
    }
    
    func getRouteStations(_ input: Operations.getRouteStations.Input) async throws -> Operations.getRouteStations.Output {
        let routeStationsResponse: Components.Schemas.ThreadStationsResponse = try loadJSONFromFile("ThreadResponse.json")
        return .ok(.init(body: .json(routeStationsResponse)))
    }
    
    func getStationSchedule(_ input: Operations.getStationSchedule.Input) async throws -> Operations.getStationSchedule.Output {
        let stationScheduleResponse: Components.Schemas.ScheduleResponse = try loadJSONFromFile("StationScheduleResponse.json")
        return .ok(.init(body: .json(stationScheduleResponse)))
    }
    
    func getScheduleBetweenStations(_ input: Operations.getScheduleBetweenStations.Input) async throws -> Operations.getScheduleBetweenStations.Output {
        let scheduleResponse: Components.Schemas.Segments = try loadJSONFromFile("RouteSearchResponse_c213_c2_with_date.json")
        return .ok(.init(body: .json(scheduleResponse)))
    }
    
    func getNearestStations(_ input: Operations.getNearestStations.Input) async throws -> Operations.getNearestStations.Output {
        let nearestStationsResponse: Components.Schemas.Stations = try loadJSONFromFile("NearestStationsResponse.json")
        return .ok(.init(body: .json(nearestStationsResponse)))
    }
    
    func getCopyright(_ input: Operations.getCopyright.Input) async throws -> Operations.getCopyright.Output {
        let copyrightResponse: Components.Schemas.CopyrightResponse = try loadJSONFromFile("CopyrightResponse.json")
        return .ok(.init(body: .json(copyrightResponse)))
    }
    
    private func loadJSONFromFile<T: Decodable>(_ filename: String) throws -> T {
        guard let fileURL = Bundle.main.url(forResource: filename, withExtension: nil) else {
            throw MockError.fileNotFound(filename)
        }
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    }
}
