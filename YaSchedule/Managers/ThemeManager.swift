//
//  ThemeManager.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 23.10.2025.
//

import SwiftUI

final class ThemeManager: ObservableObject {
    @AppStorage("darkModeIsOn") var isDarkModeOn: Bool = false
    
    var currentColorScheme: ColorScheme {
        isDarkModeOn ? .dark : .light
    }
}
