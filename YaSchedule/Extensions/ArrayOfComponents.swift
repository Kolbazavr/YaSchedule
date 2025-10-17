//
//  ArrayOfComponents.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 17.10.2025.
//

import Foundation

extension Array where Element: Waypoint {
    func filterBy(title: String) -> [any Waypoint] {
        return self.filter { waypoint in
            title.isEmpty || waypoint.title?.lowercased().contains(title.lowercased()) ?? false
        }
    }
}

//add segments
