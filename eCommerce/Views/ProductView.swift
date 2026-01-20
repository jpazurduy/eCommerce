//
//  ProductVew.swift
//  eCommerce
//
//  Created by Jorge Azurduy on 20/1/26.
//

import SwiftUI

struct ProductView: View {
    
    @StateObject private var viewModel = ProductViewModel(repository: RemoteRepository())
    @StateObject var viewModelSearch = SearchViewModel()
    @Environment(\.isSearching) private var isSearching
    
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationSplitView {
            if viewModel.isLoading && viewModel.products.isEmpty {
                ProgressView {
                    Text(searchText.isEmpty ? "Searching..." : "Searching for \(searchText)...")
                }
            } else {
                List {
                    if searchText.isEmpty && !viewModelSearch.history.isEmpty {
                        Section("Recent Queries...") {
                            ForEach(viewModelSearch.history, id: \.self) { item in
                                Button(item) {
                                    searchText = item
                                    let criteria = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                                    
                                    guard !criteria.isEmpty else { return }
                                    
                                    Task {
                                        do {
                                            try await viewModel.fetchProducts(criteria: criteria)
                                        } catch {
                                            print(error.localizedDescription)
                                        }
                                    }
                                }
                                .foregroundColor(.primary)
                            }
                            .onDelete(perform: viewModelSearch.deleteFromHistory)
                        }
                    } else {
                        ForEach(viewModel.products) { product in
                            NavigationLink {
                                ProductDetailView(product: product)
                            } label: {
                                ProductRowView(product: product)
                                    .onAppear {
                                        viewModel.loadNextPageIfNeeded(currentItem: product)
                                    }
                            }
                        }
                        
                        if viewModel.isLoadingPage {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                    
                }
                .navigationTitle("Products")
            }
        } detail: {
            Text("Select a Product")
        }
        .searchable(text: $searchText, prompt: "Search products")
        .onSubmit(of: .search) {
            viewModelSearch.addToHistory(searchText)
            let criteria = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard !criteria.isEmpty else { return }
            
            Task {
                do {
                    try await viewModel.fetchProducts(criteria: criteria)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    ProductView()
}
