//
//  Spec_OpsTests.swift
//  Spec-OpsTests
//
//  Created by Dimitris Poluzos on 18/5/26.
//

import Testing
import Foundation
@testable import Spec_Ops

@Suite("Product Tests")
struct Spec_OpsTests {

    @Test func testValidProductDecoding() async throws {
        let json = """
                {"name":"Dell XPS 13","category":"Laptop","price":"€999","description":"Great laptop"}
                """
        let data = Data(json.utf8)
        let product = try JSONDecoder().decode(Product.self, from: data)
        
        #expect(product.name == "Dell XPS 13")
        #expect(product.price == "€999")
    }

    @Test func testInvalidProductDecoding() async throws {
        let json = """
                {"name":"Dell XPS 13","category":"Laptop","price": 999,"description":"Great laptop"}
                """
        let data = Data(json.utf8)
        
        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(Product.self, from: data)
        }
    }
    @Test func testLaptopCategoryIcon(){
        let icon = CategoryIcon.iconName(for: "laptop")
        #expect(icon == "laptopcomputer")
    }
}
