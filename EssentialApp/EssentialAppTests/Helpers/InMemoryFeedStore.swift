//
//  InMemoryFeedStore.swift
//  EssentialAppTests
//
//  Created by Julius on 23/05/2024.
//

import Foundation
import essential_feed_case_study

class InMemoryFeedStore: FeedStore {
    private(set) var feedCache: CachedFeed?
    private var feedImageDataCache: [URL: Data] = [:]
    
    private init(feedCache: CachedFeed? = nil) {
        self.feedCache = feedCache
    }
    
    func deleteCachedFeed() throws {
        feedCache = nil
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        feedCache = CachedFeed(feed: feed, timestamp: timestamp)
    }
    
    func retrieve() throws -> CachedFeed? {
        feedCache
    }
    
    static var empty: InMemoryFeedStore {
        InMemoryFeedStore()
    }
    
    static var withExpiredFeedCache: InMemoryFeedStore {
        InMemoryFeedStore(feedCache: CachedFeed(feed: [], timestamp: Date.distantPast))
    }
    
    static var withNonExpiredFeedCache: InMemoryFeedStore {
        InMemoryFeedStore(feedCache: CachedFeed(feed: [], timestamp: Date()))
    }
}

extension InMemoryFeedStore: FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws {
        //insert data in the dictionary
        feedImageDataCache[url] = data
    }
    
    func retrieve(dataForURL url: URL) throws -> Data? {
        //retrieve data from the dict synchronously
        feedImageDataCache[url]
    }
}
