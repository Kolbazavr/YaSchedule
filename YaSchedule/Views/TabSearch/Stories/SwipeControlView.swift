//
//  SwipeControlView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 26.10.2025.
//

import SwiftUI

struct SwipeControlView: View {
    let swipeUpAction: () -> Void
    let swipeDownAction: () -> Void
    let swipeLeftAction: () -> Void
    let swipeRightAction: () -> Void
    
    init(
        swipeUpAction: @escaping () -> Void = {},
        swipeDownAction: @escaping () -> Void = {},
        swipeLeftAction: @escaping () -> Void = {},
        swipeRightAction: @escaping () -> Void = {}
    ) {
        self.swipeUpAction = swipeUpAction
        self.swipeDownAction = swipeDownAction
        self.swipeLeftAction = swipeLeftAction
        self.swipeRightAction = swipeRightAction
    }
    
    var body: some View {
        HStack {
            Group {
                Color.clear.contentShape(Rectangle()).onTapGesture { swipeRightAction() }
                Color.clear.contentShape(Rectangle())
                Color.clear.contentShape(Rectangle()).onTapGesture { swipeLeftAction() }
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 20)
                    .onEnded { gesture in
                        respond(to: gesture.translation)
                    }
            )
        }
    }
    
    private func respond(to gestureTranslation: CGSize) {
        guard max(abs(gestureTranslation.width), abs(gestureTranslation.height)) > 50 else { return }
        
        switch swiftStupidAngle(from: gestureTranslation) {
        case (-105)...(-75): withAnimation { swipeUpAction() }
        case (-15)...(15): withAnimation { swipeRightAction() }
        case (75)...(105): withAnimation { swipeDownAction() }
        case (165)...(180), (-180)...(-165): withAnimation { swipeLeftAction() }
        default: break
        }
    }
    
    private func swiftStupidAngle(from translation: CGSize) -> Double {
        let vector = CGPoint(x: translation.width, y: translation.height)
        let angle = atan2(vector.y, vector.x)
        return Double(angle) * 180 / Double.pi
    }
}

#Preview {
    SwipeControlView(
        swipeUpAction: {},
        swipeDownAction: {},
        swipeLeftAction: {},
        swipeRightAction: {}
    )
}
