//
//  AppState.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 13.03.2024.
//

struct AppState: IState {
    
    var mainScreenState: MainScreenState
    
    init() {
        self.mainScreenState = .init(favouriteCurrencies: [], currencies: [])
    }
}
