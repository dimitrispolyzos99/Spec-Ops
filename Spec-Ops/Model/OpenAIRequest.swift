//
//  OpenAIRequest.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 17/5/26.
//

import Foundation

struct OpenAIRequest: Encodable {
    let model: String
    let messages: [Message]
    
    struct Message: Encodable {
        let role: String
        let content: String
    }
}

struct OpenAIResponse: Decodable {
    let choices: [Choice]
    
    struct Choice: Decodable {
        let message: Message
        
        struct Message: Decodable {
            let content: String
        }
    }
}
