//
//  RemoteRepository.swift
//  eCommerce
//
//  Created by Jorge Azurduy on 20/1/26.
//

import Foundation

enum WebError: Error {
    case requestFailed(Error)
    case serverError(statusCode: Int)
    case badURL
    case unknown(Error)
    case noData
    case noConnection
    case parsingData
}

class RemoteRepository: Repository {
    
    private var sessionConfiguration = URLSessionConfiguration.default
    var session: URLSession!
    private var dataTask: URLSessionDataTask?
    private var contentType = "application/json"

    init() {
        self.sessionConfiguration = URLSessionConfiguration.default
        self.sessionConfiguration.timeoutIntervalForRequest = 30.0
        self.sessionConfiguration.timeoutIntervalForResource = 30.0
        self.session = URLSession(configuration: self.sessionConfiguration)
    }
    
    func handleDecodingError(_ error: DecodingError) {
        switch error {

        case .keyNotFound(let key, let context):
            print("❌ Key not found:", key.stringValue)
            print("Path:", codingPath(context.codingPath))
            print("Description:", context.debugDescription)

        case .typeMismatch(let type, let context):
            print("❌ Type mismatch:", type)
            print("Path:", codingPath(context.codingPath))
            print("Description:", context.debugDescription)

        case .valueNotFound(let type, let context):
            print("❌ Value not found:", type)
            print("Path:", codingPath(context.codingPath))
            print("Description:", context.debugDescription)

        case .dataCorrupted(let context):
            print("❌ Data corrupted")
            print("Path:", codingPath(context.codingPath))
            print("Description:", context.debugDescription)

        @unknown default:
            print("❌ Unknown decoding error")
        }
    }

    func codingPath(_ path: [CodingKey]) -> String {
        path.map { $0.stringValue }.joined(separator: " → ")
    }

    
    func fetchProduct(criteria: String, page: Int = 1) async throws -> [Product] {
        
        let pathURL = Path.productPath(keyword: criteria, page: page)
        
        guard let url = URL(string: pathURL) else {
            throw WebError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(ApiConstant.apiKey, forHTTPHeaderField: "x-rapidapi-key")

        let (data, response) = try await session.data(for: request)
        
        if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
            throw WebError.serverError(statusCode: response.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            let productResponse = try decoder.decode(ProductResponse.self, from: data)
            
            let stacks = productResponse.item.props.pageProps.initialData.searchResult.itemStacks
            let products = stacks.compactMap { $0.items }
            let fullProducts = products.flatMap { $0.elements }
            return fullProducts
        } catch let error as DecodingError {
            handleDecodingError(error)
            throw WebError.parsingData
        } catch {
            print(error.localizedDescription)
            throw WebError.parsingData
        }
    }
}

