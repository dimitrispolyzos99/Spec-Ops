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
    
    private let apiKey = ProcessInfo.processInfo.environment["GROQ_API_KEY"] ?? ""
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
                    [{"name":"...","category":"...","price":"€...","description":"..."}]
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
            throw NetworkError.invalidResponse
        }
        
        let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        
        guard let content = decoded.choices.first?.message.content else {
            throw NetworkError.decodingFailed
        }
        
        guard let jsonData = content.data(using: .utf8),
              let products = try? JSONDecoder().decode([Product].self, from: jsonData) else {
            throw NetworkError.decodingFailed
        }
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        return products
    }
    func fetchProductImage(query: String) async throws -> String {
        let accessKey = ProcessInfo.processInfo.environment["UNSPLASH_API_KEY"] ?? ""
        
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

