//
//  ProductRowView.swift
//  eCommerce
//
//  Created by Jorge Azurduy on 20/1/26.
//

import Foundation
import SwiftUI

struct ProductRowView: View {
    var product: Product
    
    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(url: URL(string: product.image ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Color.gray
            }
            .frame(width: 150, height: 150, alignment: .leading)
            .background(.red)
             
            Spacer()
            
            VStack(alignment: .leading) {
                Text(product.name)
                    .lineLimit(2)
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundStyle(.black)
                
                Text(product.price?.description ?? String(0.0))
                    .font(.default)
                    .fontWeight(.light)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
            }
            .background(Color.accentColor)
        }
    }
}

#Preview {
    ProductRowView(product: Product())
}
