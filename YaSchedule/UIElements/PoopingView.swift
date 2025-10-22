//
//  PoopingView.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 15.10.2025.
//

import SwiftUI

struct PoopingView: View {
    @Binding var isPooping: Bool
    
    @State private var isPaused: Bool = true
    @State private var poopingStartTime: TimeInterval = Date().timeIntervalSinceReferenceDate
    
    private let requiredFrameHeight: CGFloat
    private let fattingAmount: CGFloat
    private let fatSectionHeight: CGFloat
    private let mainColor: Color
    private let rectCornerRadius: CGFloat
    private let poopingRectHeight: CGFloat
    private let poopedOutCircleSize: CGFloat
    private let spacing: CGFloat
    private let horizontalPadding: CGFloat
    
    init(
        fattingAmount: CGFloat = 20,
        fatSectionHeight: CGFloat = 20,
        mainColor: Color = .orange,
        rectCornerRadius: CGFloat = 20,
        poopingRectHeight: CGFloat = 128,
        poopedOutCircleSize: CGFloat = 40,
        spacing: CGFloat = 16,
        horizontalPadding: CGFloat = 16,
        isPooping: Binding<Bool> = .constant(false)
    ) {
        self.requiredFrameHeight = poopingRectHeight + spacing + poopedOutCircleSize
        self.fattingAmount = horizontalPadding * 2 >= fattingAmount ? fattingAmount : horizontalPadding * 2
        self.fatSectionHeight = fatSectionHeight
        self.mainColor = mainColor
        self.rectCornerRadius = rectCornerRadius
        self.poopingRectHeight = poopingRectHeight
        self.poopedOutCircleSize = poopedOutCircleSize
        self.spacing = spacing
        self.horizontalPadding = horizontalPadding
        self._isPooping = isPooping
    }
    
    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation(minimumInterval: nil, paused: isPaused)) { timeline in
                let time = timeline.date.timeIntervalSinceReferenceDate
                let elapsed = time - poopingStartTime
                
                let totalProgress: CGFloat = CGFloat(elapsed).truncatingRemainder(dividingBy: 1)
                let fattingProgress: CGFloat = min(1, totalProgress * 2)
                let poopingProgress: CGFloat = max(0, (totalProgress - 0.5) * 2)
                let rectWidth: CGFloat = geometry.size.width - horizontalPadding * 2
                
                mainCanvas(fatnessProgress: fattingProgress, poopingProgress: poopingProgress, rectWidth: rectWidth)
                    .onChange(of: isPooping) { _, currentlyPooping in
                        isPaused = !currentlyPooping
                        poopingStartTime = Date().timeIntervalSinceReferenceDate
                    }
            }
            .offset(y: (poopedOutCircleSize + spacing) / 2)
        }
        .frame(height: requiredFrameHeight)
    }
    
    @ViewBuilder
    private func mainCanvas(fatnessProgress: CGFloat = 0, poopingProgress: CGFloat = 0, rectWidth: CGFloat) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.5, color: mainColor))
            context.addFilter(.blur(radius: 10))
            context.drawLayer { graphContext in
                for index in [0,1,2] {
                    if let resolvedSymbol = context.resolveSymbol(id: index) {
                        graphContext.draw(resolvedSymbol, at: CGPoint(x: size.width / 2, y: 0), anchor: .top)
                    }
                }
            }
        } symbols: {
            rect(rectWidth: rectWidth).tag(0)
            fatSection(fatnessProgress: fatnessProgress, poopingProgress: poopingProgress, rectWidth: rectWidth).tag(1)
            circle(poopingProgress: poopingProgress).tag(2)
        }
        .allowsHitTesting(false)
    }
    
    @ViewBuilder
    private func rect(rectWidth: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: rectCornerRadius, style: .continuous)
            .fill(mainColor)
            .frame(width: rectWidth, height: poopingRectHeight)
    }
    
    @ViewBuilder
    private func fatSection(fatnessProgress: CGFloat = 0, poopingProgress: CGFloat = 0, rectWidth: CGFloat = 0) -> some View {
        let currentAddedFat: CGFloat = fattingAmount * (fatnessProgress - poopingProgress * 2)
        let finalPositionY: CGFloat = poopingRectHeight - fatSectionHeight
        
        RoundedRectangle(cornerRadius: rectCornerRadius, style: .continuous)
            .fill(mainColor)
            .frame(width: rectWidth + currentAddedFat, height: max(0, fatSectionHeight * fatnessProgress))
            .offset(y: finalPositionY * fatnessProgress)
    }
    
    @ViewBuilder
    private func circle(poopingProgress: CGFloat = 0) -> some View {
        let initialPositionY: CGFloat = poopingRectHeight - poopedOutCircleSize
        let finalOffsetY: CGFloat = spacing + poopedOutCircleSize
        let offsetY: CGFloat = (finalOffsetY + 10) * poopingProgress
        
        Circle()
            .fill(mainColor)
            .frame(width: poopedOutCircleSize, height: poopedOutCircleSize)
            .offset(y: initialPositionY)
            .offset(y: offsetY)
            .onChange(of: offsetY) { _, newValue in
                stopAnimation(when: newValue >= finalOffsetY)
            }
    }
    
    private func stopAnimation(when reachedFinalPositionY: Bool) {
        if reachedFinalPositionY {
            isPooping = false
        }
    }
}

#Preview {
    PoopingView().background {
        Rectangle().fill(
            ImagePaint(
                image: Image(systemName: "square.split.diagonal.2x2.fill"),
                sourceRect: CGRect(x: 0, y: 0, width: 2, height: 2),
                scale: 1
            )
        )
        .foregroundStyle(.gray.opacity(0.4))
    }
}

