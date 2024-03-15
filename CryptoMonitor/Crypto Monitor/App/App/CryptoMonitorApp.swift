//
//  CryptoMonitorApp.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 13.03.2024.
//

import SwiftUI
import SwiftData

// MARK: - CryptoMonitorApp
@main
struct CryptoMonitorApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(DefaultStore<AppState, AppActions>(reducer: appReducer(appState:appAction:), state: .init()))
        }
        .modelContainer(sharedModelContainer)
    }
}

// MARK: - AppReducer
fileprivate func appReducer(appState: AppState, appAction: AppActions) -> AppState {
    switch appAction {
    case .mainScreenAction(let action):
        appState.mainScreenState = mainScreenReducer(mainScreenState: appState.mainScreenState, mainScreenAction: action)
    case .shopsScreenAction(action: let action):
        appState.shopsScreenState = shopsScreenReducer(shopsScreenState: appState.shopsScreenState, shopsScreenAction: action)
    case .setLoading(loading: let loading):
        appState.isLoading = loading
    }
    return appState
}

// MARK: - ShopsScreenReducer
fileprivate func shopsScreenReducer(shopsScreenState: ShopsScreenState, shopsScreenAction: ShopsScreenActions) -> ShopsScreenState {
    switch shopsScreenAction {
    case .none:
        break
    case .fetchShops(let shops):
        return ShopsScreenState(shops: shops)
    case .selectShop(let id):
        shopsScreenState.selectedShopId = id
    }
    return shopsScreenState
}

// MARK: - MainScreenReducer
fileprivate func mainScreenReducer(mainScreenState: MainScreenState, mainScreenAction: MainScreenActions) -> MainScreenState {
    switch mainScreenAction {
    case .none:
        break
    case .fetchCurrencies(let currencies):
        mainScreenState.currencies = currencies
    case .selectCurrency(let id):
        mainScreenState.selectedCurrency = mainScreenState.currencies.first(where: { $0.id == id })
    case .updateCurrencies(let currencies):
        mainScreenState.favouriteCurrencies = currencies
    case .searchCurrency(let text):
        mainScreenState.currencies = mainScreenState.currencies.filter { $0.name.contains(text) }
    }
    return mainScreenState
}
