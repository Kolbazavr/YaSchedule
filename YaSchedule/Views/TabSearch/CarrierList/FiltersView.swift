//
//  FiltersView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 18.10.2025.
//

import SwiftUI

struct FiltersView: View {
    @EnvironmentObject private var navigationVM: NavigationViewModel
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("Время отправления")
                .font(.system(size: 24, weight: .bold))
                .padding(.vertical, 16)
            ForEach(DayPeriod.allCases, id: \.self) { filterOption in
                HStack {
                    Text(filterOption.rawValue)
                        .font(.system(size: 17))
                    Spacer()
                    Button {
                        viewModel.toggleFilterOption(filterOption)
                    } label: {
                        Image(systemName: viewModel.selectedDayPeriods.contains(filterOption) ? "checkmark.square.fill" : "square")
                            .font(.system(size: 24))
                            .foregroundStyle(.ypBlack)
                    }
                }
                .frame(height: 60)
                
            }
            Text("Показывать варианты с пересадками")
                .font(.system(size: 24, weight: .bold))
                .padding(.vertical, 16)
            ForEach([true, false], id: \.self) { isAllowed in
                HStack {
                    Text(isAllowed ? "Yes" : "No")
                        .font(.system(size: 17))
                    Spacer()
                    Button {
                        viewModel.isTransfersAllowed.toggle()
                    } label: {
                        Image(systemName: viewModel.isTransfersAllowed == isAllowed ? "record.circle" : "poweroff")
                            .font(.system(size: 20))
                            .foregroundStyle(.ypBlack)
                    }
                }
                .frame(height: 60)
            }
            Spacer()
            Button("Apply") {
                navigationVM.navigateBack()
            }
            .buttonStyle(CustomButtonStyle())
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    let client = MockClient()
    let cityStationsProvider = CityStationsProvider(client: client)
    let routesProvider = RoutesProvider(client: client)
    FiltersView()
        .environmentObject(AppViewModel(cityStationsProvider: cityStationsProvider, routesProvider: routesProvider))
        .environmentObject(NavigationViewModel())
}
