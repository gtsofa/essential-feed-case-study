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
    
    // a litle abstraction
    public typealias SaveResult = Error?
    public typealias LoadResult = LoadFeedResult
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        // invoke a method i.e message passing to an object
        // load command need to trigger a retrieve
        store.retrieve { error in
            if let error = error {
                completion(.failure(error))
            }
        }
        
    }
    
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

// map [FeedItem] to [LocalFeedItem] to be used on the store

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map {
            LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url)
        }
    }
}
