//
//  NetworkManager.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 17/5/26.
//

import Foundation


enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid Response"
        case .decodingFailed:
            return "Decoding Failed"
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let apiKey = Secrets.groqAPIKey
    private let baseURL = "https://api.groq.com/openai/v1/chat/completions"
    
    func fetchProducts(query: String) async throws -> [Product] {
        
        guard let url = URL(string: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        let requestBody = OpenAIRequest(
            model: "llama-3.3-70b-versatile",
            messages: [
                .init(role: "system", content: """
                    You are an expert tech hardware advisor for European customers.
                    When asked about hardware recommendations:
                    - Respond ONLY with a valid JSON array, no markdown, no backticks, no extra text.
                    - Suggest products that best match ALL requirements mentioned by the user.
                    - Use European pricing in EUR, always include the € symbol in the price field.
                    - Format strictly:
                    [{"name":"...","category":"...","price":"€...","description":"...","rating":4.7,"reviewCount":1245,"matchScore":92,"badge":"bestOverall","keyFeatures":["...","...","..."],"pros":["...","..."],"cons":["...","..."],"specs":[{"label":"CPU","value":"..."},{"label":"RAM","value":"..."}]}]
                    - rating: a number 0.0 to 5.0 (one decimal).
                    - reviewCount: a realistic integer.
                    - matchScore: integer 0 to 100, how well THIS product fits the user's query. The best match should be highest.
                    - badge: ONLY one of these exact strings, or omit the field entirely: "bestOverall", "bestPerformance", "bestValue", "bestDisplay". Assign each badge to at most ONE product. Most products should have NO badge.
                    - keyFeatures: 3 to 4 short highlight strings (e.g. "16GB RAM", "144Hz display").
                    - pros: 2 to 3 short advantages.
                    - cons: 1 to 2 short drawbacks (be honest).
                    - specs: 3 to 5 objects with "label" and "value" (e.g. CPU, RAM, Storage, Display, Battery). Keep values short.
                    - Min 4 items. Description should be one concise sentence explaining why it fits the user's needs.
                    - Max 8 items
                    """),
                .init(role: "user", content: query)
            ]
        )
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            if let httpResponse = response as? HTTPURLResponse {
                print("🔴 HTTP STATUS:", httpResponse.statusCode)
                print("🔴 RESPONSE BODY:", String(data: data, encoding: .utf8) ?? "nil")
            }
            throw NetworkError.invalidResponse
        }
        
        let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        
        guard let content = decoded.choices.first?.message.content else {
            throw NetworkError.decodingFailed
        }
        
        guard let jsonData = content.data(using: .utf8) else {
            throw NetworkError.decodingFailed
        }

        do {
            let products = try JSONDecoder().decode([Product].self, from: jsonData)
            try await Task.sleep(nanoseconds: 2_000_000_000)
            return products
        } catch {
            print("🔴 DECODING ERROR:", error)
            print("🔴 RAW JSON:", String(data: jsonData, encoding: .utf8) ?? "nil")
            throw NetworkError.decodingFailed
        }
    }
    func fetchProductImage(query: String) async throws -> String {
        let accessKey = Secrets.unsplashAPIKey
        // Encode το query για URL
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        
        guard let url = URL(string: "https://api.unsplash.com/search/photos?query=\(encodedQuery)&per_page=1&orientation=landscape") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        let decoded = try JSONDecoder().decode(UnsplashResponse.self, from: data)
        
        guard let imageURL = decoded.results.first?.urls.regular else {
            throw NetworkError.decodingFailed
        }
        
        return imageURL
    }

}

