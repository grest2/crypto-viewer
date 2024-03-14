//
//  SecondTitleModifier.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 14.03.2024.
//

import SwiftUI

struct SecondTitleModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .bold()
            .font(.title2)
            .padding(.top, 18.0)
            .padding(.leading, 8.0)
            .foregroundColor(Colors.textPrimary)
    }
}
