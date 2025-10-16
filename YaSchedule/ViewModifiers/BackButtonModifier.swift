//
//  BackButtonModifier.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import SwiftUI

struct BackButtonModifier: ViewModifier {
    @EnvironmentObject private var navigationVM: NavigationViewModel
    @EnvironmentObject private var viewModel: AppViewModel
    
    let waypointIndex: Int
        func body(content: Content) -> some View {
            content
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        BackButton {
                            let isFinished = viewModel.backButtonTapped(with: waypointIndex)
                            isFinished ? navigationVM.navigateToMain() : navigationVM.navigate(to: .citySearch(waypointIndex))
                        }
                    }
                }
        }
}
