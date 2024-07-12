//
//  CoreDataFeedStore+FeedStore.swift
//  essential-feed-case-study
//
//  Created by Julius on 12/05/2024.
//

import Foundation

extension CoreDataFeedStore: FeedStore {
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.deleteCache(in: context)
            })
        }
    }
    
    public func insert(_ feed: [essential_feed_case_study.LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            completion(Result {
                // create a contex
                //save the context
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
                
                // try to save context
                try context.save()
            })
        }
        
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            completion(Result(catching: {
                try ManagedCache.find(in: context).map { cache in
                    CachedFeed(
                        feed: cache.localFeed, timestamp: cache.timestamp)
                }
            }))
        }
    }
}
