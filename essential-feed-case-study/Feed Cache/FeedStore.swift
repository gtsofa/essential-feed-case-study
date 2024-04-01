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
    // use typealias for readability
    typealias DeletionResult = Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InsertionResult = Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    //error, nil, found(with feedimages array)
    typealias RetrievalResult = Result<CachedFeed?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func retrieve(completion: @escaping RetrievalCompletion)
}
