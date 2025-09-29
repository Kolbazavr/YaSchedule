//
//  ContentView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 28.09.2025.
//

import OpenAPIRuntime
import OpenAPIURLSession
import SwiftUI

struct ContentView: View {
    private let apiKey: String = ""
    
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, Yandex Schedule!")
        }
        .padding()
        .onAppear {
//            testFetchStations()
//            testCarrierInfo()
//            testCopyright()
//            testNearestCity()
//            testRouteSearch()
//            testStationSchedule()
//            testAllStations()
//            testStationsThread()
        }
    }
    
    func testFetchStations() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = NearestStationsService(
                    client: client,
                    apikey: apiKey
                )

                print("Fetching stations...")
                let stations = try await service.getNearestStations(
                    lat: 59.864177,
                    lng: 30.319163,
                    distance: 50
                )
                print("Successfully fetched stations: \(stations)")
            } catch {
                print("Error fetching stations: \(error)")
            }
        }
    }
    func testCarrierInfo() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                let service = CarrierService(client: client, apikey: apiKey)
                
                print("Fetching carrier info...")
                
                let carrierInfo = try await service.getCarrier(with: "SU", in: "iata")
                
                print("Successfully fetched carrier info: \(carrierInfo)")
            } catch {
                print("Error fetching carrier info: \(error)")
            }
        }
    }
    func testCopyright() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                let service = CopyrightService(client: client, apikey: apiKey)
                
                print("Fetching copyright...")
                
                let copyright = try await service.getCopyright()
                
                print("Successfully fetched copyright: \(copyright)")
            } catch {
                print("Error fetching copyright: \(error)")
            }
        }
    }
    func testNearestCity() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                let service = NearestCityService(client: client, apikey: apiKey)
                
                print("Fetching nearest city...")
                
                let nearestCity = try await service.getNearestCity(lat: 55.751244, lng: 37.618423, distance: 50)
                
                print("Successfully fetched nearest city: \(nearestCity)")
            } catch {
                print("Error fetching nearest city: \(error)")
            }
        }
    }
    func testRouteSearch() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                let service = RoutsSearchService(client: client, apikey: apiKey)
                
                print("Fetching routs...")
                
                let routs = try await service.getRouts(from: "c213", to: "c2")
                
                print("Successfully fetched routs: \(routs)")
            } catch {
                print("Error fetching routs: \(error)")
            }
        }
    }
    func testStationSchedule() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                let service = StationScheduleService(client: client, apikey: apiKey)
                
                print("Fetching station schedule...")
                
                let schedule = try await service.getSchedule(of: "s9600213")
                
                print("Successfully fetched station schedule: \(schedule)")
            } catch {
                print("Error fetching station schedule: \(error)")
            }
        }
    }
    func testAllStations() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                let service = StationsListService(client: client, apikey: apiKey)
                
                print("Fetching all stations...")
                
                let allStations = try await service.getAllStations()
                
                print("Successfully fetched all stations: \(allStations)")
            } catch {
                print("Error fetching all stations: \(error)")
            }
        }
    }
    func testStationsThread() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                let service = StationsThreadService(client: client, apikey: apiKey)
                
                print("Fetching stations thread...")
                
                let stationsThread = try await service.getStationsThread(threadUid: "098S_2_2")
                
                print("Successfully fetched stations thread: \(stationsThread)")
            } catch {
                print("Error fetching stations thread: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
