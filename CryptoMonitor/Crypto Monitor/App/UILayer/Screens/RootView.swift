//
//  RootView.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 14.03.2024.
//

import SwiftUI

// MARK: - RootView
struct RootView: View {
    
    private enum CurrentTab: Int {
        
        case main = 1
        case shop
        case account
        case settings
    }
    
    @State private var currentTab: CurrentTab = .main
    
    @Environment(DefaultStore<AppState, AppActions>.self) var store
    
    var body: some View {
        NavigationStack {
            ZStack {
                tabView
                
                if store.state.isLoading {
                    LoaderBlur()
                }
            }
        }
    }
    
    private var tabView: some View {
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
                .tag(currentTab.rawValue)
            
            ShopsScreenView()
                .environment(store)
                .tabItem {
                    Label(
                        title: { Text("Shops") },
                        icon: { Image(systemName: "cart.fill") }
                    )
                }
                .tag(currentTab.rawValue)
            
            ContentView()
                .environment(store)
                .tabItem {
                    Label(
                        title: { Text("Personal\nAccount") },
                        icon: { Image(systemName: "person") }
                    )
                }
                .tag(currentTab.rawValue)
            
            ContentView()
                .environment(store)
                .tabItem {
                    Label(
                        title: { Text("Settings") },
                        icon: { Image(systemName: "gearshape.fill") }
                    )
                }
                .background(Color.yellow)
                .tag(currentTab.rawValue)
        }
        .accentColor(Colors.selected)
    }
}

#Preview {
    RootView()
}
