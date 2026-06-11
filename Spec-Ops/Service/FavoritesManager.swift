//
//  FavoritesManager.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 11/6/26.
//

import Foundation

final class FavoritesManager {

    static let shared = FavoritesManager()
    private init() {}

    private let key = "favoriteProducts"

    // MARK: - Read
    func allFavorites() -> [Product] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []   // πρώτη φορά: κανένα favorite
        }
        let products = (try? JSONDecoder().decode([Product].self, from: data)) ?? []
        return products
    }

    // MARK: - Check
    func isFavorite(_ product: Product) -> Bool {
        allFavorites().contains { $0.name == product.name }
    }

    // MARK: - Toggle
    func toggle(_ product: Product) {
        var favorites = allFavorites()

        if let index = favorites.firstIndex(where: { $0.name == product.name }) {
            favorites.remove(at: index)
        } else {
            favorites.append(product)
        }

        save(favorites)
    }

    // MARK: - Write
    private func save(_ products: [Product]) {
        guard let data = try? JSONEncoder().encode(products) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
