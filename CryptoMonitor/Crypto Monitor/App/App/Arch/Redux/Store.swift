//
//  Store.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 13.03.2024.
//

import Observation

/// Протокол описывающий стор для хранения
protocol IStore {
    
    associatedtype TAction: Action
    associatedtype TState: IState
    
    func send(action: TAction)
}

/// Реализация стора
@Observable final class DefaultStore<TState: IState, TAction: Action>: IStore {
    
    // MARK: Props
    private let reducer: Reducer<TState, TAction>
    
    private(set) var state: TState
    
    // MARK: - Init
    init(reducer: @escaping Reducer<TState, TAction>, state: TState) {
        self.reducer = reducer
        self.state = state
    }
    
    // MARK: Methods
    func send(action: TAction) {
        state = reducer(state, action)
    }
}
