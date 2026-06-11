//
//  ProductBadge.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 6/6/26.
//


import Foundation

enum ProductBadge: String, Codable {
    case bestOverall
    case bestPerformance
    case bestValue
    case bestDisplay

    var displayTitle: String {
        switch self {
        case .bestOverall:     return "Best Overall"
        case .bestPerformance: return "Best Performance"
        case .bestValue:       return "Best Value"
        case .bestDisplay:     return "Best Display"
        }
    }
}
