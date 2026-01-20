//
//  Repository.swift
//  eCommerce
//
//  Created by Jorge Azurduy on 20/1/26.
//
import Foundation

protocol Repository {
    func fetchProduct(criteria: String, page: Int) async throws -> [Product]
}
