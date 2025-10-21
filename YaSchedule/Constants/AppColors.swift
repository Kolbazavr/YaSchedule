//
//  AppColors.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 21.10.2025.
//

import SwiftUI

enum AppColors {
    case background
    case searchBarBackground
    case text
    
    var color: Color {
        return switch self {
        case .background: .ypWhite
        case .searchBarBackground: .ypSearchBar
        case .text: .ypBlack
        }
    }
}
