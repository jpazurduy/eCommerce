//
//  Product.swift
//  eCommerce
//
//  Created by Jorge Azurduy on 20/1/26.
//
import Foundation
import Combine

class ProductViewModel: ObservableObject {
    private let repository: any Repository
    
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingPage: Bool = false
    
    // Pagination state
    private(set) var currentCriteria: String = ""
    private(set) var currentPage: Int = 0
    private(set) var canLoadMore: Bool = true
    
    init(repository: any Repository) {
        self.repository = repository
    }
    
    // Starts a new search and loads page 1
    func fetchProducts(criteria: String) async throws {
        await MainActor.run {
            self.isLoading = true
            self.products = []
            self.currentCriteria = criteria
            self.currentPage = 0
            self.canLoadMore = true
        }
        do {
            try await loadNextPage()
        } catch {
            await MainActor.run {
                self.isLoading = false
            }
            throw error
        }
        await MainActor.run {
            self.isLoading = false
        }
    }
    
    // Loads the next page if allowed
    @MainActor
    func loadNextPageIfNeeded(currentItem: Product?) {
        guard canLoadMore, !isLoadingPage, !isLoading else { return }
        guard let currentItem else { return }
        
        // Trigger when the current item is within the last N items
        let thresholdIndex = max(products.count - 5, 0)
        if let index = products.firstIndex(where: { $0.id == currentItem.id }), index >= thresholdIndex {
            Task {
                try? await self.loadNextPage()
            }
        }
    }
    
    // Actually performs the next page load
    private func loadNextPage() async throws {
        let nextPage = currentPage + 1
        await MainActor.run {
            self.isLoadingPage = true
        }
        do {
            let newItems = try await repository.fetchProduct(criteria: currentCriteria, page: nextPage)
            await MainActor.run {
                if newItems.isEmpty {
                    self.canLoadMore = false
                } else {
                    self.currentPage = nextPage
                    // Avoid duplicates if backend can repeat items across pages
                    let existingIDs = Set(self.products.compactMap { $0.id })
                    let filtered = newItems.filter { item in
                        if let id = item.id {
                            return !existingIDs.contains(id)
                        } else {
                            // If id is nil, append anyway
                            return true
                        }
                    }
                    self.products.append(contentsOf: filtered)
                }
                self.isLoadingPage = false
            }
        } catch {
            await MainActor.run {
                self.isLoadingPage = false
                self.canLoadMore = false
            }
            throw error
        }
    }
}
