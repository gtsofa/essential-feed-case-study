//
//  FeedStoreSpy.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 11/03/2024.
//

import Foundation
import essential_feed_case_study

class FeedStoreSpy: FeedStore {
    
    enum ReceivedMessage: Equatable {
        case deleteCachedFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }
    // combine all msgs
    private(set) var receivedMessages = [ReceivedMessage]()
    
    // use typealias for readability
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()
    // mtd to be invoked in sut
    // implements the behavior we expect
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        // then we capture the completions
        deletionCompletions.append(completion)
        //incase of the above
        receivedMessages.append(.deleteCachedFeed)
    }
    
    func completeDeletion(with error: NSError, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        // we capture items and timestam msgs :)
        receivedMessages.append(.insert(feed, timestamp))
    }
    
    func completeInsertion(with error: NSError, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
    // spy needs to implement the retrieve mtd
    // inside the mtd we can append receivedmsgs so we can assert
    // in our tests
    func retrieve() {
        receivedMessages.append(.retrieve)
    }
}
