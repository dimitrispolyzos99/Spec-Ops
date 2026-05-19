//
//  ResultsViewModel.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 17/5/26.
//

import Foundation

final class ResultsViewModel {
    
    private(set) var products: [Product] = []
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func fetchProducts(query: String) {
        Task {
            do {
                let results = try await NetworkManager.shared.fetchProducts(query: query)
                await MainActor.run {
                    self.products = results
                    self.onDataUpdated?()
                }
            } catch {
                await MainActor.run {
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
}
