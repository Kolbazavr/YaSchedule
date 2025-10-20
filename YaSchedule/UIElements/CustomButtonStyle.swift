//
//  CustomButtonStyle.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 18.10.2025.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .bold))
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(.ypBlue)
            .foregroundStyle(.ypWhiteUni)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .animation(.easeOut, value: configuration.isPressed)
    }
}
