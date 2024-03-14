//
//  PrimaryButton.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 14.03.2024.
//

import SwiftUI

// MARK: - PrimaryButton
struct PrimaryButton: View {
    
    // MARK: - Props
    @State private var opacity: Double = 1.0
    
    private let buttonTitle: String
    private let imageName: String
    private let buttonAction: VoidAction
    
    // MARK: - Init
    init(buttonTitle: String, imageName: String, buttonAction: @escaping VoidAction) {
        self.buttonTitle = buttonTitle
        self.imageName = imageName
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        Button(action: {
            withAnimation {
                opacity = 0.8
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                opacity = 1.0
            }
            buttonAction()
        }) {
            VStack(alignment: .center) {
                ZStack(alignment: .center) {
                    Circle()
                        .fill(Colors.primary)
                        .frame(width: 64.0)
                    Image(imageName)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 38.0, height: 38.0)
                        .foregroundColor(Colors.textSecondary)
                }
                Text(buttonTitle)
                    .modifier(SecondaryTextModifier())
                    .lineLimit(3)
                    .bold()
            }
        }
        .buttonStyle(.plain)
        .opacity(opacity)
    }
}

// MARK: - Preview
#Preview {
    PrimaryButton(buttonTitle: "Купить", imageName: "buy", buttonAction: {})
}
