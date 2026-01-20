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
        ZStack {
            Color.yellow
                .ignoresSafeArea()
                
            VStack {
                AsyncImage(url: URL(string: product.image ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 250, height: 250, alignment: .leading)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.black, lineWidth: 2)
                }
                .shadow(radius: 27)
                .padding(.bottom, 30)
                
                Text(product.name)
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundStyle(.black)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Price: \(product.price?.description ?? String(0.0))" )
                    .font(.default)
                    .fontWeight(.light)
                    .foregroundStyle(.black)
                    .frame(width: 150, height: 100)
            }
            .background(.yellow)
            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .center)
        }
    }
}

#Preview {
    //ProductDetailView(product: Product())
}
