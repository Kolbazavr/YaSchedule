//
//  ProgressViewStyle.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 24.10.2025.
//

import SwiftUI

struct YaProgressBar: ProgressViewStyle {
    let height: CGFloat = 6
    
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.ypWhiteUni)
                    .frame(height: height)
                Capsule()
                    .fill(.ypBlue)
                    .frame(width: geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0), height: height)
            }
            .animation(
                (configuration.fractionCompleted ?? 0) > 0 ? .linear : nil, value: configuration.fractionCompleted)
        }
        .frame(height: height)
    }
}
