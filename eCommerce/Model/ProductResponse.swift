//
//  Product.swift
//  eCommerce
//
//  Created by Jorge Azurduy on 20/1/26.
//

import Foundation

// MARK: - Root Response
struct ProductResponse: Codable {
    let responseStatus: String
    let responseMessage: String
    let item: ItemContainer
    
    enum CodingKeys: String, CodingKey {
       case responseStatus
       case responseMessage
       case item
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        responseStatus = try container.decode(String.self, forKey: .responseStatus)
        responseMessage = try container.decode(String.self, forKey: .responseMessage)
        item = try container.decode(ItemContainer.self, forKey: .item)
        
    }
}

// MARK: - Item Container
struct ItemContainer: Codable {
    let props: ItemProps
    
    enum CodingKeys: String, CodingKey {
       case props
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        props = try container.decode(ItemProps.self, forKey: .props)
    }
}


// MARK: - Properties and Data
struct ItemProps: Codable {
    let pageProps: PageProps
    
    enum CodingKeys: String, CodingKey {
       case pageProps
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pageProps = try container.decode(PageProps.self, forKey: .pageProps)
    }

}

struct PageProps: Codable {
    let initialData: InitialData
    
    enum CodingKeys: String, CodingKey {
       case initialData
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        initialData = try container.decode(InitialData.self, forKey: .initialData)
    }

}

struct InitialData: Codable {
    let searchResult: SearchResult
    
    enum CodingKeys: String, CodingKey {
       case searchResult
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        searchResult = try container.decode(SearchResult.self, forKey: .searchResult)
    }

}

// MARK: - Search Results
struct SearchResult: Codable {
    let itemStacks: [ItemStack]
    
    enum CodingKeys: String, CodingKey {
       case itemStacks
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        itemStacks = try container.decode([ItemStack].self, forKey: .itemStacks)
    }

}

struct ItemStack: Codable {
    let items: LossyArray<Product>
}

// MARK: - Product Details
struct Product: Codable, Identifiable {
    let id: String?
    let name: String
    let price: Double?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case image
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decodeIfPresent(Double.self, forKey: .price)
        image = try container.decodeIfPresent(String.self, forKey: .image)
    }
}
