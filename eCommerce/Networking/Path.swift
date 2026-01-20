//
//  Path.swift
//  eCommerce
//
//  Created by Jorge Azurduy on 20/1/26.
//

import Foundation

struct Path {
    static let baseURL = "https://axesso-walmart-data-service.p.rapidapi.com/wlm/walmart-search-by-keyword?keyword=[criterio]&page=[numeropagina]&sortBy=best_match"
    
    static func productPath(keyword: String, page: Int) -> String {
        return baseURL.replacingOccurrences(of: "[criterio]", with: keyword).replacingOccurrences(of: "[numeropagina]", with: "\(page)")
    }
    
}
