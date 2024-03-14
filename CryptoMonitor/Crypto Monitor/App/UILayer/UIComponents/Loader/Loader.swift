//
//  Loader.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 14.03.2024.
//

import SwiftUI

struct Loader: View {
    
    @State private var rotationCoin: Double = .zero
    @State private var coinYOffset: CGFloat = .zero
    
    @State private var rotationCard: Double = .zero
    
    var body: some View {
        VStack {
            Circle()
                .trim(from: 0.0, to: 0.0)
                .stroke()
                .frame(width: 42.0, height: 42.0, alignment: .center)
                .overlay(
                    Image("coin")
                        .resizable()
                )
                .rotationEffect(.degrees(rotationCoin))
                .rotation3DEffect(
                    .degrees(30.0),
                    axis: (x: 1.0, y: 0.0, z: 0.0)
                )
                .foregroundColor(Colors.selected)
                .offset(y: coinYOffset)
                .onAppear {
                    withAnimation(
                        .timingCurve(0.55, 0, 1, 0.45)
                        .speed(0.3)
                        .delay(0.5)
                        .repeatForever(autoreverses: false)
                    ) {
                            coinYOffset = 30
                            rotationCoin = 360
                    }
                }
            
            Circle()
                .trim(from: 0.0, to: 0.0)
                .stroke()
                .frame(width: 42.0, height: 42.0, alignment: .center)
                .overlay(
                    Image("card")
                        .resizable()
                        .foregroundColor(Colors.selected)
                )
                .rotationEffect(.degrees(rotationCard))
                .rotation3DEffect(
                    .degrees(30.0),
                    axis: (x: 1.0, y: -1.0, z: 1.0)
                )
                .onAppear {
                    withAnimation(
                        .timingCurve(0.55, 0, 1, 0.45)
                        .speed(0.3)
                        .delay(0.5)
                        .repeatForever(autoreverses: false)
                    ) {
                        rotationCard = 360
                    }
                }
        }
        .frame(width: 156.0, height: 156.0)
        .background(Colors.primary)
        .cornerRadius(12.0)
    }
}

#Preview {
    Loader()
}
