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

extension Date {
    var dayPeriod: DayPeriod {
        let hour = Calendar.current.component(.hour, from: self)
        switch hour {
        case 6..<12:
            return .morning
        case 12..<18:
            return .afternoon
        case 18..<23:
            return .evening
        default:
            return .night
        }
    }
}

extension DateFormatter {
    static let scheduleDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    static let inputFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()
    
    static let outputFormatterHoursMinutes: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    static let outputFormatterDayMonth: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        return dateFormatter
    }()
}
