//
//  SplashScreen.swift
//  YaSchedule
//
//  Created by ANTON ZVERKOV on 19.10.2025.
//

import SwiftUI

struct SplashScreen: View {
    @State private var morphBlur: CGFloat = 0
    @State private var animationMorph: Bool = false
    @State private var switchedImage: Bool = false
    
    private let innerCircleSize: CGFloat = 140
    private let outerCircleSize: CGFloat = 180
    private let innerRectWidth: CGFloat = 44
    private let outerRectWidth: CGFloat = 74
    
    var body: some View {
        ZStack {
            Image(.lsBackground)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(edges: .all)
            Rectangle()
                .fill(.white)
                .offset(x: 0, y: -UIScreen.main.bounds.height / 2 + outerCircleSize / 2)
                .frame(width: outerRectWidth)
            Rectangle()
                .fill(.ypBlue)
                .offset(x: 0, y: -UIScreen.main.bounds.height / 2 + outerCircleSize / 2)
                .frame(width: innerRectWidth)
            ZStack {
                Circle()
                    .fill(.white)
                    .frame(width: 180, height: 180)
                Circle()
                    .fill(.ypBlue)
                    .frame(width: 140, height: 140)
                Rectangle()
                    .fill(switchedImage ? .white : .white)
                    .frame(width: 200, height: 200)
                    .mask {
                        Canvas { context, size in
                            context.addFilter(.alphaThreshold(min: 0.15))
                            context.addFilter(.blur(radius: morphBlur >= 20 ? 20 - (morphBlur - 20) : morphBlur))
                            context.drawLayer { graphContext in
                                if let resolvedImage = context.resolveSymbol(id: 1) {
                                    graphContext.draw(resolvedImage, at: CGPoint(x: size.width / 2, y: size.height / 2), anchor: .center)
                                }
                            }
                        } symbols: {
                            smileFace(morphBlur: morphBlur).tag(1)
                        }
                    }
                    .animation(.easeInOut, value: switchedImage)
                    .onReceive(Timer.publish(every: 0.007, on: .main, in: .common).autoconnect()) { _ in
                        if animationMorph {
                            if morphBlur <= 40 {
                                morphBlur += 0.25
                                if morphBlur.rounded() == 20 {
                                    switchedImage = true
                                }
                            }
                            if morphBlur.rounded() == 40 {
                                animationMorph = false
                                morphBlur = 0
                            }
                        }
                    }
            }
            .offset(y: outerCircleSize / 2)
        }
        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                animationMorph = true
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    private func smileFace(morphBlur: CGFloat) -> some View {
        if !switchedImage {
            ZStack {
                smileEyes(morphBlur: morphBlur)
                smileMouth(morphBlur: morphBlur)
            }
        } else {
            Image(.ypSmile)
                .font(.system(size: 100))
                .foregroundStyle(.white)
                .offset(y: 5)
        }
    }
    
    @ViewBuilder
    private func smileEyes(morphBlur: CGFloat) -> some View {
        Rectangle()
            .frame(width: 10, height: 62 - morphBlur * 2)
            .offset(x: -32, y: 4)
        Rectangle()
            .frame(width: 10, height: 62 - morphBlur * 2)
            .offset(x: 32, y: 4)
    }
    
    @ViewBuilder
    private func smileMouth(morphBlur: CGFloat) -> some View {
        Rectangle()
            .frame(width: 48, height: 10)
            .offset(y: -40 + morphBlur * 4)
    }
}

#Preview {
    SplashScreen()
}
