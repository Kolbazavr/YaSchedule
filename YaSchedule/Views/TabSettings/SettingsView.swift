//
//  SettingsView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var navigationVM: NavigationViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @State var isDarkTheme: Bool = false
    
    var body: some View {
        VStack {
            Group {
                Toggle("Темная тема", isOn: themeManager.$isDarkModeOn)
                    .tint(.ypBlue)
                Button {
                    navigationVM.navigate(to: .copyright)
                } label: {
                    HStack {
                        Text("Пользовательское соглашение")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24, weight: .regular))
                    }
                }
            }
            .tint(AppColors.text.color)
            .font(.system(size: 17, weight: .regular))
            .foregroundStyle(AppColors.text.color)
            .frame(height: 60)
            
            Spacer()
            VStack(spacing: 16) {
                Group {
                    Text("Приложение использует API «Яндекс.Расписания»")
                    Text("Версия 1.0 (beta)")
                }
                .font(.system(size: 12, weight: .regular))
            }
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    SettingsView()
        .environmentObject(NavigationViewModel())
        .environmentObject(ThemeManager())
}
