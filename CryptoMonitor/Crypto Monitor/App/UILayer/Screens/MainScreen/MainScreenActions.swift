//
//  MainScreenActions.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 13.03.2024.
//

enum MainScreenActions: Action {
    
    case none
    case fetchCurrencies(currencies: [CryptoCurrencyModel])
    case selectCurrency(id: String)
    case updateCurrencies
    case searchCurrency(text: String)
}
