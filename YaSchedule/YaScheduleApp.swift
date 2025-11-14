//
//  YaScheduleApp.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 28.09.2025.
//

import SwiftUI
import OpenAPIURLSession

@main
struct YaScheduleApp: App {
    @StateObject private var appViewModel: AppViewModel
    @StateObject private var navigationVM = NavigationViewModel()
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var storiesManager = StoriesManager()
    @State private var showSplashScreen: Bool = true
    
    @Namespace var appNamespace
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                AppView()
                    .environmentObject(appViewModel)
                    .environmentObject(navigationVM)
                    .environmentObject(themeManager)
                    .environmentObject(storiesManager)
                    .environmentObject(NamespaceWrapper(appNamespace))
                
                    .preferredColorScheme(themeManager.currentColorScheme)
                if showSplashScreen {
                    SplashScreen()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showSplashScreen = false
                }
            }
        }
    }
    init() {
        var client: APIProtocol
        if let stringValue = ProcessInfo.processInfo.environment["USE_MOCK"], let boolValue = Bool(stringValue), boolValue {
            print("❗️Using mock client❗️")
            client = MockClient()
        } else {
            do {
                client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport(),
                    middlewares: [APIKeyMiddleware()]
                )
            } catch {
                fatalError("Client initialization failed: \(error)")
            }
        }
        let cityStationsProvider = CityStationsProvider(client: client)
        let routesProvider = RoutesProvider(client: client)
        _appViewModel = .init(wrappedValue: .init(cityStationsProvider: cityStationsProvider, routesProvider: routesProvider))
    }
}
