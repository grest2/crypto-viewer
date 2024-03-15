//
//  CryptoShopModel.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 15.03.2024.
//

import Foundation

struct CryptoShopModel: Decodable {
    
    let id: String
    let name: String
    let imageName: String
    let url: URL
}
