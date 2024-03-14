//
//  MainScreenView.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 13.03.2024.
//

import SwiftUI
import Combine
import Observation

// MARK: - MainScreenView
struct MainScreenView: View {
    
    // MARK: Item
    struct Item: Identifiable {
        
        let id: String
        let name: String
        let usdPrice: String
        let symbol: String
        
        var image: Image {
            .init(uiImage: UIImage(named: symbol) ?? .init(named: "default_currency_icon")!)
        }
    }
    
    // MARK: Props
    @Environment(DefaultStore<AppState, AppActions>.self) var store
    
    @State private var items: [Item]
    
    @State private var favouriteItems: [Item]
    
    private let cryptoService: any ICryptoMonitorService = CryptoMonitorService()
    
    // MARK: - Init
    init(items: [Item] = [], favouriteItems: [Item] = []) {
        _items = State(initialValue: items)
        _favouriteItems = State(initialValue: favouriteItems)
    }
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading) {
                    Text("Your favourite currencies:")
                        .modifier(SecondTitleModifier())
                    
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(favouriteItems, id: \.id) { item in
                                VStack(alignment: .center) {
                                    item.image
                                        .resizable()
                                        .frame(width: 44.0, height: 44.0)
                                    
                                    Text(item.symbol)
                                        .modifier(SecondaryTextModifier())
                                }
                                .padding(.leading, 8.0)
                            }
                        }
                    }
                    .background(Colors.primary)
                }
                .padding(.horizontal, 8.0)
                .padding(.vertical, 12.0)
            }
            .background(Colors.primary)
            .listRowInsets(EdgeInsets())
            
            ForEach(items, id: \.id) { item in
                HStack {
                    item.image
                        .resizable()
                        .frame(width: 44.0, height: 44.0)
                    
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .modifier(SecondaryTextModifier())
                            .bold()
                            .padding(.leading, 8.0)
                        
                        Text(item.symbol)
                            .font(.body)
                            .padding(.leading, 8.0)
                            .foregroundColor(Colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Spacer()
                        
                        Text("\(item.usdPrice) $")
                            .padding(.bottom, 16.0)
                            .font(.callout)
                            .foregroundColor(Colors.textSecondary)
                    }
                }
                .listRowBackground(Colors.primary)
                .listRowSeparator(.hidden)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Colors.background.edgesIgnoringSafeArea(.all))
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
        currenciesTracking()
    }
    
    func currenciesTracking() {
        _ = withObservationTracking {
            return store.state.mainScreenState.currencies
        } onChange: {
            items = store.state.mainScreenState
                .currencies.map(itemMapper(from:))
            if !items.isEmpty {
                favouriteItems = [items[0], items[1], items[2]]
            }
        }
    }
    
    func fetchCurrencies() async throws {
        let result = try await cryptoService.fetch(url: "https://api.coincap.io/v2/assets", result: ApiResponse<[CryptoCurrencyModel]>.self).get()
        store.send(action: .mainScreenAction(action: .fetchCurrencies(currencies: result.data)))
    }
    
    func itemMapper(from model: CryptoCurrencyModel) -> Item {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let price = Decimal(string: model.priceUsd)
        return .init(id: model.id,
                     name: model.name,
                     usdPrice: String(
                        format: "%.2f",
                        (price! as NSDecimalNumber).doubleValue
                     ), 
                     symbol: model.symbol
        )
    }
}

// MARK: - Preview
#Preview {
    MainScreenView(
        items: [
            .init(id: "BTC", name: "bitcoin", usdPrice: "24", symbol: "BTC")
        ],
        favouriteItems: [
            .init(id: "BTC", name: "bitcoin", usdPrice: "24", symbol: "BTC")
        ]
    )
    .environment(DefaultStore<AppState, AppActions>(reducer: mockReducer, state: .init()))
}

fileprivate func mockReducer(appState: AppState, appActions: AppActions) -> AppState {
    return appState
}
