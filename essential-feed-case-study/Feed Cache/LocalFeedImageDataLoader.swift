//
//  LocalFeedImageDataLoader.swift
//  essential-feed-case-study
//
//  Created by Julius on 09/05/2024.
//

import Foundation

public final class LocalFeedImageDataLoader {
    private let store: FeedImageDataStore
    
    public init(store: FeedImageDataStore) {
        self.store = store
    }
}

extension LocalFeedImageDataLoader: FeedImageDataCache {
    public enum SaveError: Error {
        case failed
    }
    
    public func save(_ data: Data, for url: URL) throws {
        do {
            try store.insert(data, for: url)
        } catch {
            throw SaveError.failed
        }
    }
}

extension LocalFeedImageDataLoader: FeedImageDataLoader {
    // we dont need a result
    
    public enum LoadError: Swift.Error {
        case failed
        case notFound
    }
    
    // we don't need a task 'LoadImageDataTask:FeedImageDataLoaderTask'
    
    // sync no completion blocks
    public func loadImageData(from url: URL) throws -> Data {
        // transform it to a docatch
        do {
            if let imageData = try store.retrieve(dataForURL: url) {
                return imageData
            }
        } catch {
            throw LoadError.failed
        }
        throw LoadError.notFound
    }
}
