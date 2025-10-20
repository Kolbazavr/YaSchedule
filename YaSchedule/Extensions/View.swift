//
//  View.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import SwiftUI

extension View {
    func withCustomBackButton(waypointIndex: Int? = nil) -> some View {
        modifier(BackButtonModifier())
    }
}
