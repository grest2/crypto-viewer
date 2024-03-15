//
//  AppState.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 13.03.2024.
//

final class AppState: IState {
    
    var mainScreenState: MainScreenState
    var shopsScreenState: ShopsScreenState
    
    var isLoading: Bool = false
    
    init() {
        mainScreenState = .init(favouriteCurrencies: [], currencies: [])
        shopsScreenState = .init()
    }
}
