//
//  RemoteFeedLoader.swift
//  essential-feed-case-study
//
//  Created by Julius on 01/02/2024.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping(HTTPClientResult) -> Void )
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success(data, response):
                print(">>>data: \(data)")
                //if statuscode == 200 and we can make the data
                // then complete with success>>array of items
                if response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) {
                    print(">>rootItems: \(root.items)")
                    completion(.success(root.items.map {$0.item }))
                } else {
                    completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

private struct Root: Decodable {
    let items: [Item]
}

private struct Item: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
    
    var item: FeedItem {
        return FeedItem(id: id, description: description, location: location, imageURL: image)
    }
}

