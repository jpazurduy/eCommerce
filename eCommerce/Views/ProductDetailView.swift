//
//  ProductDetailView.swift
//  eCommerce
//
//  Created by Jorge Azurduy on 20/1/26.
//

import SwiftUI

struct ProductDetailView: View {
    var product: Product
    
    var body: some View {
        VStack {
//            AsyncImage(url: URL(string: product.image)) { image in
//                image
//                    .resizable()
//                    .scaledToFit()
//            } placeholder: {
//                ProgressView()
//            }
            Text(product.name)
            Text(product.price?.description ?? String(0.0))
        }
    }
}

#Preview {
    
}
