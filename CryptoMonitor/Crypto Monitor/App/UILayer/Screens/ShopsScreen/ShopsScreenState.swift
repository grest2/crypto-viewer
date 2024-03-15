//
//  ShopsScreenState.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 15.03.2024.
//

import Foundation

final class ShopsScreenState: IState {
    
    var shops: [CryptoShopModel]
    
    var selectedShopId: String?
    
    init(shops: [CryptoShopModel] = [], selectedShopId: String? = nil) {
        self.shops = shops
        self.selectedShopId = selectedShopId
    }
}
