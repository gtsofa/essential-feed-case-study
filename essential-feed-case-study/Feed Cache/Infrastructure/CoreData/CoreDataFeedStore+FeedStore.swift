//
//  CoreDataFeedStore+FeedStore.swift
//  essential-feed-case-study
//
//  Created by Julius on 12/05/2024.
//

import Foundation

extension CoreDataFeedStore: FeedStore {
    public func deleteCachedFeed() throws {
        try ManagedCache.deleteCache(in: context)
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        // create a contex
        //save the context
        let managedCache = try ManagedCache.newUniqueInstance(in: context)
        managedCache.timestamp = timestamp
        managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
        
        // try to save context
        try context.save()
    }
    
    public func retrieve() throws -> CachedFeed? {
        try ManagedCache.find(in: context).map {
            CachedFeed(
                feed: $0.localFeed, timestamp: $0.timestamp)
        }
    }

}
