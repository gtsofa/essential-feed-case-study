//
//  LocalFeedLoader.swift
//  essential-feed-case-study
//
//  Created by Julius on 07/03/2024.
//

import Foundation

private final class FeedCachePolicy {
    
    private let calendar = Calendar(identifier: .gregorian)
    
    private var maxCacheAgeInDays: Int {
        return 7
    }
    
    // Date type is a struct and it's immutable in this scope
    func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        //print("current>> \(currentDate())")//current>> 2024-03-14 11:06:44 +0000
        print("maxCacheAge>>\(maxCacheAge)")//2024-03-14 11:06:45 +0000
        return date < maxCacheAge
    }
}

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    private let cachePolicy = FeedCachePolicy()
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}
    
extension LocalFeedLoader: FeedLoader {
    public typealias LoadResult = LoadFeedResult
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        // invoke a method i.e message passing to an object
        // load command need to trigger a retrieve
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .failure(error):
                completion(.failure(error))
                
            case let .found(feed, timestamp) where self.cachePolicy.validate(timestamp, against: self.currentDate()):
                completion(.success(feed.toModels()))
                
            case .found, .empty:
                completion(.success([]))
            }
        }
    }
}

    
extension LocalFeedLoader {
    // a litle abstraction
    public typealias SaveResult = Error?
    
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        //need to invoke a mtd
        //deleteCachedFeed needs to tell us if it succeeded or not
        // we can enforce this operation to sync or
        // let the feed store run the work async
        // let give it a closure and allow the work to run asynchronously in background queue
        // not to block the interface (UI)
        store.deleteCachedFeed { [weak self] error in
            // check if instance has been deallocated return
            guard let self = self else { return }
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
                
            } else {
                // store needs self
                //it may generate memory leak
                //                self.store.insert(items, timestamp: self.currentDate(), completion: completion)
                self.cache(feed, with: completion)
                
            }
        }
        
        // We don't only need to check if the mtd was invoked
        // we need to check the order of those methods invocation as well - IMPORTANT
    }
    
    private func cache(_ feed: [FeedImage], with completion: @escaping(SaveResult) -> Void) {
        store.insert(feed.toLocal(), timestamp: currentDate()) { [weak self] insertionError in
            guard self != nil else { return }
            
            completion(insertionError)
        }
    }
    
}

extension LocalFeedLoader {
    public func validateCache() {
        // remember we only need to delete cached feed
        // only when there is error/failure(i.e cache is not valid)
        store.retrieve { [weak self] result in
            // check if self is still in memory before carrying on
            guard let self = self else { return }
            
            switch result {
            case .failure:
                self.store.deleteCachedFeed { _ in }
                
            // we found a cache which is not valid so delete it
            case let .found(_, timestamp) where !self.cachePolicy.validate(timestamp, against: self.currentDate()):
                self.store.deleteCachedFeed { _ in }
                
            // adding new cases to the result type will break
            case .empty, .found: break
            }
        }
        
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
