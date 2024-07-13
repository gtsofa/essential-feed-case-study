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
    
    private var retrievalCompletions = [(FeedImageDataStore.RetrievalResult) -> Void]()
    // Stub
    private var insertionResult: Result<Void, Error>? //[(FeedImageDataStore.InsertionResult) -> Void]()
    private(set) var receivedMsgs = [Message]()
    
    var requestedURLs = [URL]()
    
    func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        //capture msgs for use in our test
        receivedMsgs.append(.retrieve(dataFor: url))
        retrievalCompletions.append(completion)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrieval(with data: Data?, at index: Int = 0) {
        retrievalCompletions[index](.success(data))
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
