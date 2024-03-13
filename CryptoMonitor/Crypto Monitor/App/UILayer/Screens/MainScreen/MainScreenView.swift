//
//  MainScreenView.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 13.03.2024.
//

import SwiftUI

struct MainScreenView: View {
    
    @State private var store: DefaultStore<AppState, AppActions> = .init(
        reducer: reducer(appState:appAction:),
        state: .init())
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

fileprivate func reducer(appState: AppState, appAction: AppActions) -> AppState {
    
    return appState
}

#Preview {
    MainScreenView()
}
