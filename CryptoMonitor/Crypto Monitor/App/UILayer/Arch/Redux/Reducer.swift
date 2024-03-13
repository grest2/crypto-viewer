//
//  Reducer.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 13.03.2024.
//

typealias Reducer<TState, TAction> = (TState, TAction) -> TState where TState: State, TAction: Action
