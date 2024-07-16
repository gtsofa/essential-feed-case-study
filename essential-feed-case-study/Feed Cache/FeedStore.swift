//
//  FeedStore.swift
//  essential-feed-case-study
//
//  Created by Julius on 07/03/2024.
//

import Foundation

public typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)

// a helper class representing the framework side
// to help us define the abstract interface teh use case needs for
// its collaborator
//making sure we don't leak framework details into the use case
// turned into a protocol at the end
public protocol FeedStore {
    func deleteCachedFeed() throws
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws
    func retrieve() throws -> CachedFeed?
}
