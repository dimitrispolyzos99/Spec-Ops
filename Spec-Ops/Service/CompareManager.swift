//
//  CompareManager.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 12/6/26.
//

import Foundation

final class CompareManager {

    static let shared = CompareManager()
    private init() {}

    let maxProducts = 3

    private(set) var selectedProducts: [Product] = []

    func isSelected(_ product: Product) -> Bool {
        selectedProducts.contains { $0.name == product.name }
    }

    /// Επιστρέφει false αν δεν χωράει άλλο προϊόν (έφτασε το max)
    @discardableResult
    func toggle(_ product: Product) -> Bool {
        if let index = selectedProducts.firstIndex(where: { $0.name == product.name }) {
            selectedProducts.remove(at: index)
            return true
        }

        guard selectedProducts.count < maxProducts else {
            return false
        }
        selectedProducts.append(product)
        return true
    }

    func clear() {
        selectedProducts.removeAll()
    }
}
