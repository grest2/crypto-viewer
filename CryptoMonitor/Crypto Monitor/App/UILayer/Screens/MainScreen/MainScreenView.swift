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
    
    private let timer = Timer.publish(
        every: 60.0, on: .main, in: .common
    ).autoconnect()
    
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
            
            buyButtons
            
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
                .listRowBackground(listRowRounding(itemId: item.id))
                .listRowSeparator(.hidden)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Colors.background.edgesIgnoringSafeArea(.all))
        .onAppear {
            store.send(action: .setLoading(loading: true))
            onAppear()
        }
        .onReceive(timer) { _ in
            print("_LOG_ _MainScreenView_: timer update works")
            Task {
                store.send(action: .setLoading(loading: true))
                try await fetchCurrencies()
            }
        }
    }
    
    private var buyButtons: some View {
        HStack(alignment: .top) {
            PrimaryButton(
                buttonTitle: "Buy",
                imageName: "buy",
                buttonAction: onBuyButtonTap
            )
            
            Spacer()
            
            PrimaryButton(
                buttonTitle: "Sell",
                imageName: "sell",
                buttonAction: onSellButtonTap
            )
            
            Spacer()
            
            PrimaryButton(
                buttonTitle: "Personal\nAccount",
                imageName: "person",
                buttonAction: onPersonalAccountTap
            )
        }
        .listRowBackground(Colors.background)
        .listRowSeparator(.hidden)
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
        print("_LOG_ _MainScreenView_: currencies fetched: \(result.data)")
        store.send(action: .mainScreenAction(action: .fetchCurrencies(currencies: result.data)))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            store.send(action: .setLoading(loading: false))
        }
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
    
    func onBuyButtonTap() {
        print("was tapped buy")
    }
    
    func onSellButtonTap() {
        print("was tapped sell")
    }
    
    func onPersonalAccountTap() {
        print("was tapped to personal account")
    }
    
    func listRowRounding(itemId: String) -> some View {
        guard !items.isEmpty else {
            return Colors.primary
                .clipShape(
                    .rect())
        }
        switch itemId {
        case items.first!.id:
            return Colors.primary.clipShape(
                .rect(
                    topLeadingRadius: 12.0,
                    bottomLeadingRadius: 0.0,
                    bottomTrailingRadius: 0.0,
                    topTrailingRadius: 12.0
                )
            )
        case items.last!.id:
            return Colors.primary.clipShape(
                .rect(
                    topLeadingRadius: 0.0,
                    bottomLeadingRadius: 12.0,
                    bottomTrailingRadius: 12.0,
                    topTrailingRadius: 0.0
                )
            )
        default:
            return Colors.primary.clipShape(.rect())
        }
    }
    
    func primaryButtonConfiguration(
        name: String,
        icon: String,
        action: @escaping VoidAction)
    -> some View {
        PrimaryButton(
            buttonTitle: name,
            imageName: icon,
            buttonAction: action
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
