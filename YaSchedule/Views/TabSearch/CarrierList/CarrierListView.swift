//
//  CarrierListView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 17.10.2025.
//

import SwiftUI

struct CarrierListView: View {
    @EnvironmentObject private var navigationVM: NavigationViewModel
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
            Text("\(viewModel.route[0].description ?? "🖊️") → \(viewModel.route[1].description ?? "🍍")")
                .font(.system(size: 24, weight: .bold))
                .padding(16)
            if viewModel.filteredSegments().isEmpty && !viewModel.isLoadingSomething {
                Spacer()
                Text("No carriers found")
                    .font(.system(size: 18, weight: .bold))
                    .padding(16)
                Spacer()
            } else {
                List {
                    ForEach(viewModel.filteredSegments(), id: \.self) { segment in
                        Button {
                            let carrierCode = segment.thread?.carrier?.code
                            navigationVM.navigate(to: .carrierDetails(carrierYaCode: carrierCode))
                        } label: {
                            CarrierCardView(
                                departureTime: segment.departure?.toTimeOnly() ?? "🚂",
                                arrivalTime: segment.arrival?.toTimeOnly() ?? "🚂",
                                duration: (segment.duration ?? 0) / 60 / 60,
                                carrierImage: segment.thread?.carrier?.logo ?? "",
                                carrierName: segment.thread?.carrier?.title ?? "Unknown carrier",
                                transferPoint: nil,
                                tripDate: segment.departure?.toDateMonth() ?? "🔅",
                                hasTransfers: segment.has_transfers ?? false
                            )
                            .foregroundStyle(.ypBlack)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 4, leading: 16, bottom: 4, trailing: 16))
                        .onAppear {
                            if segment == viewModel.segments.last {
                                viewModel.searchRoutes(false)
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            Button {
                navigationVM.navigate(to: .searchFilters)
            } label: {
                HStack {
                    Text("Add filters")
                    if !viewModel.selectedDayPeriods.isEmpty {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 8))
                            .foregroundStyle(.ypRed)
                    }
                }
            }
            .buttonStyle(CustomButtonStyle())
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .overlay {
            if viewModel.isLoadingSomething {
                ProgressView("Searching carriers...")
            }
        }
    }
}

#Preview {
    let client = MockClient()
    let cityStationsProvider = CityStationsProvider(client: client)
    let routesProvider = RoutesProvider(client: client)
    CarrierListView()
        .environmentObject(AppViewModel(cityStationsProvider: cityStationsProvider, routesProvider: routesProvider))
        .environmentObject(NavigationViewModel())
}
