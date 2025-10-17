//
//  BackButtonModifier.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import SwiftUI

struct BackButtonModifier: ViewModifier {
    @EnvironmentObject private var navigationVM: NavigationViewModel
    
    let waypointIndex: Int
        func body(content: Content) -> some View {
            content
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        BackButton {
                            navigationVM.navigateBack()
                        }
                    }
                }
        }
}
