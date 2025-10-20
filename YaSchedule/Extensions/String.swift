//
//  String.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 17.10.2025.
//

import Foundation

extension String {
    func toTimeOnly() -> String {
        guard let date = DateFormatter.inputFormatter.date(from: self) else { return "" }
        return DateFormatter.outputFormatterHoursMinutes.string(from: date)
    }
    
    func toDateMonth() -> String {
        guard let date = DateFormatter.inputFormatter.date(from: self) else { return "" }
        return DateFormatter.outputFormatterDayMonth.string(from: date)
    }
}
