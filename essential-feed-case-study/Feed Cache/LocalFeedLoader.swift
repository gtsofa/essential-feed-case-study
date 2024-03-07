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
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ items: [FeedItem], completion: @escaping (SaveResult) -> Void) {
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
                self.cache(items, with: completion)
                
            }
        }
        
        // We don't only need to check if the mtd was invoked
        // we need to check the order of those methods invocation as well - IMPORTANT
    }
    
    private func cache(_ items: [FeedItem], with completion: @escaping(SaveResult) -> Void) {
        store.insert(items, timestamp: currentDate()) { [weak self] insertionError in
            guard self != nil else { return }
            
            completion(insertionError)
        }
    }
}
