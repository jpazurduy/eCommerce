//
//  ProductVew.swift
//  eCommerce
//
//  Created by Jorge Azurduy on 20/1/26.
//

import SwiftUI

struct ProductView: View {
    
    @StateObject private var viewModel = ProductViewModel(repository: RemoteRepository())
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationSplitView {
            if viewModel.isLoading && viewModel.products.isEmpty {
                ProgressView {
                    Text(searchText.isEmpty ? "Searching..." : "Searching for \(searchText)...")
                }
            } else {
                List {
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
                .navigationTitle("Products")
            }
        } detail: {
            Text("Select a Product")
        }
        .searchable(text: $searchText, prompt: "Search products")
        .onSubmit(of: .search) {
            let criteria = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !criteria.isEmpty else { return }
            Task {
                do {
                    try await viewModel.fetchProducts(criteria: criteria)
                    searchText = ""
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
