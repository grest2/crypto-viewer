//
//  CryptoMonitorApp.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 13.03.2024.
//

import SwiftUI
import SwiftData

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
            MainScreenView()
                .environment(DefaultStore<AppState, AppActions>(reducer: appReducer(appState:appAction:), state: .init()))
                .background(Color.init(red: 0.64, green: 0.69, blue: 0.64, opacity: 1.0))
        }
        .modelContainer(sharedModelContainer)
    }
}

fileprivate func appReducer(appState: AppState, appAction: AppActions) -> AppState {
    switch appAction {
    case .mainScreenAction(let action):
        appState.mainScreenState = mainScreenReducer(mainScreenState: appState.mainScreenState, mainScreenAction: action)
        return appState
    }
}

fileprivate func mainScreenReducer(mainScreenState: MainScreenState, mainScreenAction: MainScreenActions) -> MainScreenState {
    switch mainScreenAction {
    case .none:
        break
    case .fetchCurrencies(let currencies):
        mainScreenState.currencies = currencies
    case .selectCurrency(let id):
        mainScreenState.selectedCurrency = mainScreenState.currencies.first(where: { $0.id == id })
    case .updateCurrencies:
        mainScreenState.currencies = []
    case .searchCurrency(let text):
        mainScreenState.currencies = mainScreenState.currencies.filter { $0.name.contains(text) }
    }
    return mainScreenState
}
