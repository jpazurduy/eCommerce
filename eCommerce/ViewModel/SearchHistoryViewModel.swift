//
//  SearchHistoryViewModel.swift
//  eCommerce
//
//  Created by Jorge Azurduy on 20/1/26.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {
    @AppStorage("search_history") private var historyData: String = ""
    @Published var history: [String] = []
    
    init() {
        history = historyData.components(separatedBy: "|").filter { !$0.isEmpty }
    }
    
    func addToHistory(_ term: String) {
        let cleanTerm = term.trimmingCharacters(in: .whitespaces)
        guard !cleanTerm.isEmpty else { return }
        
        history.removeAll { $0.lowercased() == cleanTerm.lowercased() }
        history.insert(cleanTerm, at: 0)
        
        if history.count > 10 { history = Array(history.prefix(10)) }
        historyData = history.joined(separator: "|")
    }
    
    func deleteFromHistory(at offsets: IndexSet) {
        history.remove(atOffsets: offsets)
        historyData = history.joined(separator: "|")
    }
}
