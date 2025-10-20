//
//  SearchFieldsView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import SwiftUI

struct WaypointSelectorView: View {
    @EnvironmentObject private var navigationVM: NavigationViewModel
    @EnvironmentObject private var viewModel: AppViewModel
    
    @State var isPoopingOut: Bool = false
    @State var isSwapping: Bool = false
    
    private let textFieldButtonHeight: CGFloat = 48
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                PhaseAnimator([0,1,0], trigger: isSwapping) { phase in
                    VStack {
                        ForEach(Array(viewModel.route.enumerated()), id: \.0) { waypointIndex, routePoint in
                            Button {
                                navigationVM.navigateToSelectedLocation(for: routePoint, with: waypointIndex)
                            } label: {
                                Text(routePoint.description ?? WaypointType.allCases[waypointIndex].rawValue)
                                    .lineLimit(1)
                                    .foregroundStyle(routePoint.description == nil ? .ypGrayUni : .ypBlackUni)
                                    .opacity(phase == 1 ? 0 : 1)
                                    .padding(.horizontal, 16)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(.white)
                    }
                    .frame(height: phase == 1 ? textFieldButtonHeight : textFieldButtonHeight * 2)
                }
                
                Button {
                    if viewModel.isReadyToSearch() {
                        isPoopingOut.toggle()
                    }
                    isSwapping.toggle()
                    viewModel.swapOriginAndDestination()
                } label: {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 36, height: 36)
                        .overlay {
                            Image(systemName: "arrow.2.squarepath")
                        }
                }
            }
            .padding(.horizontal, 32)
            .frame(height: 128)
            .background {
                PoopingView(
                    mainColor: .ypBlue,
                    rectCornerRadius: 20,
                    poopingRectHeight: 128,
                    spacing: 16,
                    horizontalPadding: 16,
                    isPooping: $isPoopingOut
                )
            }
            if viewModel.isReadyToSearch() {
                Button {
                    viewModel.searchRoutes()
                    navigationVM.navigate(to: .carrierList)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.ypBlue)
                        Text("Search")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .frame(width: 150, height: 60)
                }
                .opacity(isPoopingOut ? 0 : 1)
                .animation(.snappy, value: isPoopingOut)
                .onAppear() {
                    isPoopingOut.toggle()
                }
            }
        }
    }
}

#Preview {
    let client = MockClient()
    let cityStationsProvider = CityStationsProvider(client: client)
    let routesProvider = RoutesProvider(client: client)
    WaypointSelectorView()
        .environmentObject(AppViewModel(cityStationsProvider: cityStationsProvider, routesProvider: routesProvider))
        .environmentObject(NavigationViewModel())
}
