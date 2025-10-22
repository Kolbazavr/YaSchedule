//
//  DefaultBackground.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 21.10.2025.
//

import SwiftUI

struct DefaultBackground: ViewModifier {
    private let color: Color = AppColors.background.color
    
    func body(content: Content) -> some View {
        ZStack {
            color.ignoresSafeArea()
            content
        }
    }
}
