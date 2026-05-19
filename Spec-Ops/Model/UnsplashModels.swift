//
//  UnsplashModels.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 17/5/26.
//

import Foundation

struct UnsplashResponse: Decodable {
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Decodable {
    let urls: PhotoURLs
    
    struct PhotoURLs: Decodable {
        let regular: String
    }
}
