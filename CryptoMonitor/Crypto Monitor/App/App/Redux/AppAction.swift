//
//  AppAction.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 13.03.2024.
//

enum AppActions: Action {
    
    case mainScreenAction(action: MainScreenActions)
    case shopsScreenAction(action: ShopsScreenActions)
    
    case setLoading(loading: Bool)
}
