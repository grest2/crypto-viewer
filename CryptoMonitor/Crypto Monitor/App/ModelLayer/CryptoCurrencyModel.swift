//
//  CryptoCurrencyModel.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 13.03.2024.
//

import Foundation

struct CryptoCurrencyModel: Decodable {
    
    let id: String
    let rank: String
    let symbol: String
    let name: String
    let supply: String
    let marketCapUsd: String
    let priceUsd: String
}
