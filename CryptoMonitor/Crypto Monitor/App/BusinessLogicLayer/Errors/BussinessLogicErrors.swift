//
//  BussinessLogicErrors.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 13.03.2024.
//

enum BussinessLogicErrors: Error {
    
    case incorrectRequestBuilding
    
    case requestError(code: Int)
}
