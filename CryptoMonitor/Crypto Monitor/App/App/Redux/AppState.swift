//
//  AppState.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 13.03.2024.
//

final class AppState: IState {
    
    var isLoading: Bool = false
    
    var mainScreenState: MainScreenState
    
    init() {
        self.mainScreenState = .init(favouriteCurrencies: [], currencies: [])
    }
}
