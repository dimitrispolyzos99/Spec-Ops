//
//  Secrets.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 13/6/26.
//

import Foundation

enum Secrets {
    static var groqAPIKey: String { value(for: "GROQ_API_KEY") }
    static var unsplashAPIKey: String { value(for: "UNSPLASH_API_KEY") }

    private static func value(for key: String) -> String {
        guard let url = Bundle.main.url(forResource: "Secret", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
              let value = dict[key] as? String else {
            print("⚠️ Missing key '\(key)' in Secret.plist")
            return ""
        }
        return value
    }
}
