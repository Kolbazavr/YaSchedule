//
//  Date.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import Foundation

extension Date {
    func toString() -> String {
        return DateFormatter.scheduleDateFormatter.string(from: self)
    }
}

extension DateFormatter {
    static let scheduleDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
}
