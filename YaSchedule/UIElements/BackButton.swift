//
//  BackButton.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import SwiftUI

struct BackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
        }
        .foregroundStyle(.ypBlack)
        .font(.system(size: 17, weight: .semibold))
    }
}

#Preview {
    BackButton(action: { print("Retreat!") } )
}
