//
//  LoaderBlur.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 14.03.2024.
//

import SwiftUI

// MARK: - LoaderBlur
struct LoaderBlur: View {
    
    var body: some View {
        ZStack {
            Colors.background
                .ignoresSafeArea(.all)
                .opacity(0.6)
                .background(.ultraThinMaterial)
            Loader()
        }
    }
}

#Preview {
    LoaderBlur()
}
