//
//  MainScreenState.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 13.03.2024.
//

import Foundation

final class MainScreenState: IState {
    
    var favouriteCurrencies: [CryptoCurrencyModel]
    var currencies: [CryptoCurrencyModel]
    
    var selectedCurrency: CryptoCurrencyModel?
    
    init(favouriteCurrencies: [CryptoCurrencyModel], currencies: [CryptoCurrencyModel], selectedCurrency: CryptoCurrencyModel? = nil) {
        self.favouriteCurrencies = favouriteCurrencies
        self.currencies = currencies
        self.selectedCurrency = selectedCurrency
    }
}
