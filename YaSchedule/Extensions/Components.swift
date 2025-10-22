//
//  Settlement.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import Foundation

extension Components.Schemas.Settlement: Waypoint {
    var description: String {
        self.title ?? ""
    }
    var yandexCode: String {
        self.codes?.yandex_code ?? ""
    }
}

extension Components.Schemas.Station: Waypoint {
    var description: String {
        self.title ?? ""
    }
    var yandexCode: String {
        self.codes?.yandex_code ?? ""
    }
}

extension Components.Schemas.Segment {
    var departureSwiftDate: Date? {
        DateFormatter.inputFormatter.date(from: self.departure ?? "")
    }
    
    var arrivalSwiftDate: Date? {
        DateFormatter.inputFormatter.date(from: self.arrival ?? "")
    }
    
    var departureDayPeriod: DayPeriod? {
        departureSwiftDate?.dayPeriod
    }
}
