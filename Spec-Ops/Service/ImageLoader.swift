//
//  ImageLoader.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 6/6/26.
//

import UIKit

final class ImageLoader {

    // Ένας κοινός loader για όλη την εφαρμογή.
    static let shared = ImageLoader()
    private init() {}

    // Cache: κλειδί το URL string, τιμή η έτοιμη εικόνα.
    // Αν την έχουμε ήδη κατεβάσει, δεν ξανακατεβάζουμε.
    private let cache = NSCache<NSString, UIImage>()

    func loadImage(from urlString: String) async -> UIImage? {
        let key = urlString as NSString

        // 1. Έχουμε ήδη την εικόνα; Δώσ' τη αμέσως, χωρίς network.
        if let cached = cache.object(forKey: key) {
            return cached
        }

        // 2. Δεν την έχουμε — κατέβασέ τη.
        guard let url = URL(string: urlString) else { return nil }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }

            // 3. Αποθήκευσέ τη στο cache για την επόμενη φορά.
            cache.setObject(image, forKey: key)
            return image
        } catch {
            return nil
        }
    }
}
