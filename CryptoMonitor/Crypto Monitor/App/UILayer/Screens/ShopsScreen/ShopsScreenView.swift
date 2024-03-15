//
//  ShopsScreenView.swift
//  Crypto Monitor
//
//  Created by Kiselev Ilya on 15.03.2024.
//

import SwiftUI
import Observation

// MARK: - ShopsScreenView
struct ShopsScreenView: View {
    
    struct Item: Identifiable {
        
        let id: String
        let name: String
        let link: URL
        let image: Image
    }
    
    // MARK: Props
    @Environment(DefaultStore<AppState, AppActions>.self) var store
    
    @State private var items: [Item]
    
    init(items: [Item] = []) {
        _items = State(initialValue: items)
    }
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("Here you can see available shops:")
                        .modifier(SecondTitleModifier())
                }
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Colors.background)
            
            ForEach(items, id: \.id) { item in
                HStack {
                    item.image
                        .resizable()
                        .frame(width: 44.0, height: 44.0)
                    
                    Text(item.name)
                        .modifier(SecondaryTextModifier())
                        .bold()
                        .padding(.leading, 8.0)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Colors.primary)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Colors.background
            .edgesIgnoringSafeArea(.all)
        )
        .onAppear {
            onAppear()
        }
    }
}

// MARK: - ShopsScreenView + Private methods
private extension ShopsScreenView {
    
    func onAppear() {
        Task {
            await shopsUpdatingTracking()
            store.send(action: .shopsScreenAction(action: .fetchShops(shops: ShopProvider.shops)))
        }
        store.send(action: .setLoading(loading: true))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            store.send(action: .setLoading(loading: false))
        }
    }
    
    @MainActor
    func shopsUpdatingTracking() {
        _ = withObservationTracking {
            return store.state.shopsScreenState.shops
        } onChange: {
            items = store.state.shopsScreenState.shops
                .map { .init(id: $0.id, name: $0.name, link: $0.url, image: .init($0.imageName)) }
        }
    }
}

#Preview {
    ShopsScreenView(items: [
        .init(id: "coinbase", 
              name: "coinbase",
              link: .init(string: "https://robinhood.com/us/en/")!,
              image: .init("coinbase"))
    ])
    .environment(DefaultStore<AppState, AppActions>(reducer: mockReducer, state: .init()))
}
