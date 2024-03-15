//
//  ShopProvider.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 15.03.2024.
//

import Foundation

struct ShopProvider {
    
    static let shops: [CryptoShopModel] = [
        .init(id: "coinbase", name: "Coinbase", imageName: "coinbase", url: .init(string: "https://www.coinbase.com/")!),
        .init(id: "binance", name: "Binance", imageName: "binance", url: .init(string: "https://www.binance.com/en")!),
        .init(id: "gemini", name: "Gemini", imageName: "gemini", url: .init(string: "https://www.gemini.com/")!),
        .init(id: "bitstamp", name: "Bitstamp", imageName: "bitstamp", url: .init(string: "https://www.bitstamp.net/markets/")!),
        .init(id: "robinhood", name: "Robinhood", imageName: "robinhood", url: .init(string: "https://robinhood.com/us/en/")!)
    ]
}
