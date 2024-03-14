//
//  SecondaryTextModifier.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 14.03.2024.
//

import SwiftUI

struct SecondaryTextModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.body)
            .foregroundColor(Colors.textSecondary)
    }
}
