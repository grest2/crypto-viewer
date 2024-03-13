//
//  MainScreenView.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 13.03.2024.
//

import SwiftUI
import Combine
import Observation

struct MainScreenView: View {
    
    // MARK: Item
    struct Item: Identifiable {
        
        let id: String
        let name: String
        let image: Image
        let usdPrice: String
    }
    
    @Environment(DefaultStore<AppState, AppActions>.self) var store
    
    @State private var items: [Item]
    
    @State private var favouriteItems: [Item]
    
    private let cryptoService: any ICryptoMonitorService = CryptoMonitorService()
    
    init(items: [Item] = [], favouriteItems: [Item] = []) {
        _items = State(initialValue: items)
        _favouriteItems = State(initialValue: favouriteItems)
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Your favourite currencies")
                    .bold()
                    .font(.title2)
                    .padding(.top, 18.0)
                    .padding(.leading, 8.0)
                    .foregroundColor(.white)
                
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(favouriteItems, id: \.id) { item in
                            Image("default_currency_icon")
                        }
                    }
                }
            }
            .background(Color(red: 0.15, green: 0.15, blue: 0.15)
                .cornerRadius(12.0))
            .padding(.all, 24.0)
            
            List(items, id: \.id) { item in
                HStack {
                    item.image
                    
                    Text(item.name)
                        .bold()
                        .font(.body)
                        .padding([.leading], 16.0)
                    
                    Spacer()
                    
                    VStack {
                        Spacer()
                        
                        Text(item.usdPrice + " " + "$")
                            .padding(.bottom, 16.0)
                            .font(.callout)
                    }
                }
                .listRowBackground(Color.init(red: 0.64, green: 0.69, blue: 0.64, opacity: 1.0))
                .listRowSeparator(.hidden)
            }
            .scrollContentBackground(.hidden)
        }
        .background(Color.init(red: 0.34, green: 0.49, blue: 0.34, opacity: 1.0))
        .onAppear {
            onAppear()
        }
    }
}

// MARK: - MainScreenView + Private methods
private extension MainScreenView {
    
    func onAppear() {
        Task {
           try await fetchCurrencies()
        }
        _ = withObservationTracking {
            return store.state.mainScreenState
        } onChange: {
            items = store.state.mainScreenState
                .currencies.map {
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    let price = Decimal(string: $0.priceUsd)
                    return .init(id: $0.id,
                                 name: $0.name,
                                 image: .init("default_currency_icon"),
                                 usdPrice: String(
                                    format: "%.2f",
                                    (price! as NSDecimalNumber).doubleValue
                                 )
                    )
                }
        }
    }
    
    func fetchCurrencies() async throws {
        let result = try await cryptoService.fetch(url: "https://api.coincap.io/v2/assets", result: ApiResponse<[CryptoCurrencyModel]>.self).get()
        store.send(action: .mainScreenAction(action: .fetchCurrencies(currencies: result.data)))
    }
}

// MARK: - Preview
#Preview {
    MainScreenView(
        items: [
            .init(id: "01", name: "bitcoin", image: .init("default_currency_icon"), usdPrice: "24")
        ],
        favouriteItems: [
            .init(id: "01", name: "bitcoin", image: .init("default_currency_icon"), usdPrice: "24")
        ]
    )
    .environment(DefaultStore<AppState, AppActions>(reducer: mockReducer, state: .init()))
}

fileprivate func mockReducer(appState: AppState, appActions: AppActions) -> AppState {
    return appState
}
