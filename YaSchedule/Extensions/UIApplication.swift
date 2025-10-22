//
//  UIApplication.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
