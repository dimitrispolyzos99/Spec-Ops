//
//  Product.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 17/5/26.
//

import Foundation


nonisolated struct Product: Codable, Hashable, Sendable {
    let name: String
    let category: String
    let price: String
    let description: String
    let rating: Double?
    let reviewCount: Int?
    let badge: ProductBadge?
    let matchScore: Int?
}
