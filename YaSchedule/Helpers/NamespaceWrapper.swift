//
//  NamespaceWrapper.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 25.10.2025.
//

import SwiftUI

final class NamespaceWrapper: ObservableObject {
    var namespace: Namespace.ID

    init(_ namespace: Namespace.ID) {
        self.namespace = namespace
    }
}
