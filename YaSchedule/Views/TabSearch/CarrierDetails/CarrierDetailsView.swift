//
//  CarrierDetailsView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 20.10.2025.
//

import SwiftUI

struct CarrierDetailsView: View {
    let carrierYaCode: Int?
    
    var body: some View {
        Text("Hello, Carrier with \(carrierYaCode ?? 0) code!")
            .foregroundStyle(AppColors.text.color)
    }
}

#Preview {
    CarrierDetailsView(carrierYaCode: 123)
}
