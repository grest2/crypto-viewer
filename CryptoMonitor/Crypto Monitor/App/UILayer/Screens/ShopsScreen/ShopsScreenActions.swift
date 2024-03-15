//
//  ShopsScreenActions.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 15.03.2024.
//

import Foundation

enum ShopsScreenActions: Action {
    
    case none
    case fetchShops(shops: [CryptoShopModel])
    case selectShop(id: String)
}
