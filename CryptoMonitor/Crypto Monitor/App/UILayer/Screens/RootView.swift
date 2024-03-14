//
//  RootView.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 14.03.2024.
//

import SwiftUI

struct RootView: View {
    
    @Environment(DefaultStore<AppState, AppActions>.self) var store
    
    var body: some View {
        TabView {
            MainScreenView()
                .environment(store)
                .tabItem {
                    Label(
                        title: { Text("Main") },
                        icon: { Image(systemName: "house") }
                    )
                }
                .toolbarBackground(Colors.background, for: .tabBar)
            ContentView()
                .environment(store)
                .tabItem {
                    Label(
                        title: { Text("Shop") },
                        icon: { Image(systemName: "cart.fill") }
                    )
                }
            ContentView()
                .environment(store)
                .tabItem {
                    Label(
                        title: { Text("Personal\nAccount") },
                        icon: { Image(systemName: "person") }
                    )
                }
            ContentView()
                .environment(store)
                .tabItem {
                    Label(
                        title: { Text("Settings") },
                        icon: { Image(systemName: "gearshape.fill") }
                    )
                }
                .background(Color.yellow)
        }
        .accentColor(Colors.selected)
    }
}

#Preview {
    RootView()
}
