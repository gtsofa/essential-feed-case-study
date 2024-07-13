//
//  FeedImageDataStoreSpy.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 10/05/2024.
//

import Foundation
import essential_feed_case_study

class FeedImageDataStoreSpy: FeedImageDataStore {
    //.insert(data: data, for: url)
    enum Message: Equatable {
        case retrieve(dataFor: URL)
        case insert(data: Data, for: URL)
    }
    
    private var retrievalResult: Result<Data?, Error>?//= [(FeedImageDataStore.RetrievalResult) -> Void]()
    // Stub
    private var insertionResult: Result<Void, Error>? //[(FeedImageDataStore.InsertionResult) -> Void]()
    // spy can also be a stub; as it still capture receivedmsgs
    private(set) var receivedMsgs = [Message]()
    
    var requestedURLs = [URL]()
    
    // all methods are sync :)
    //implement sync version
    func retrieve(dataForURL url: URL) throws -> Data? {
        //capture msgs for use in our test
        // stub msgs
        receivedMsgs.append(.retrieve(dataFor: url))
        return try retrievalResult?.get()
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrieval(with data: Data?, at index: Int = 0) {
        //capture stub
        retrievalResult = .success(data)
    }
    
    func insert(_ data: Data, for url: URL) throws {
        receivedMsgs.append(.insert(data: data, for: url))
        try insertionResult?.get()
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        //capture stub instead of complete insertion completion
        insertionResult = .failure(error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        //capture stub
        insertionResult = .success(())
    }
    
}
