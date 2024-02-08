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
            case .success:
                completion(.failure(.invalidData))
                
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

