//
//  ApiResponse.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 13.03.2024.
//

import Foundation

struct ApiResponse<T: Decodable>: Decodable {
    
    let data: T
}
