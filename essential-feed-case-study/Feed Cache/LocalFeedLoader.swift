//
//  LocalFeedLoader.swift
//  essential-feed-case-study
//
//  Created by Julius on 07/03/2024.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}
    
extension LocalFeedLoader {
    public typealias LoadResult = Swift.Result<[FeedImage], Error>
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        // invoke a method i.e message passing to an object
        // load command need to trigger a retrieve
        
        //sync
        completion(LoadResult {
            if let cache = try store.retrieve(),
               FeedCachePolicy.validate(cache.timestamp, against: self.currentDate()) {
                return cache.feed.toModels()
            }
            return []
        })
    }
}

    
extension LocalFeedLoader: FeedCache {
    // a litle abstraction
    public typealias SaveResult = FeedCache.Result
    
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        /*//need to invoke a mtd
        //deleteCachedFeed needs to tell us if it succeeded or not
        // we can enforce this operation to sync or
        // let the feed store run the work async
        // let give it a closure and allow the work to run asynchronously in background queue
        // not to block the interface (UI)
        store.deleteCachedFeed { [weak self] deletionResult in
            // check if instance has been deallocated return
            guard let self = self else { return }
            
            switch deletionResult {
            case .success:
                // store needs self
                //it may generate memory leak
                //                self.store.insert(items, timestamp: self.currentDate(), completion: completion)
                self.cache(feed, with: completion)
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
        
        // We don't only need to check if the mtd was invoked
        // we need to check the order of those methods invocation as well - IMPORTANT*/
        
        // now we use sync
        completion(SaveResult {
            try store.deleteCachedFeed()
            try store.insert(feed.toLocal(), timestamp: currentDate())
        })
    }
    
}

extension LocalFeedLoader {
    public typealias ValidationResult = Result<Void, Error>
    private struct InvalidCache: Error {}
    
    public func validateCache(completion: @escaping(ValidationResult) -> Void) {
        /*// remember we only need to delete cached feed
        // only when there is error/failure(i.e cache is not valid)
        store.retrieve { [weak self] result in
            // check if self is still in memory before carrying on
            guard let self = self else { return }
            
            switch result {
            case .failure:
                self.store.deleteCachedFeed(completion: completion)
                
            // we found a cache which is not valid so delete it
            case let .success(.some(cache)) where !FeedCachePolicy.validate(cache.timestamp, against: self.currentDate()):
                self.store.deleteCachedFeed(completion: completion)
                
            // adding new cases to the result type will break
            case .success:
                completion(.success(()))
            }
        }*/
        
        // sync
        completion(ValidationResult {
            do {
                if let cache = try store.retrieve(),
                   !FeedCachePolicy.validate(cache.timestamp, against: self.currentDate()) {
                    throw InvalidCache()
                }
            } catch {
                try store.deleteCachedFeed()
            }
        })
        
    }
}

// map [FeedItem] to [LocalFeedItem] to be used on the store

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map {
            LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)
        }
    }
}

// inverse

private extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        return map {
            FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)
        }
    }
}
