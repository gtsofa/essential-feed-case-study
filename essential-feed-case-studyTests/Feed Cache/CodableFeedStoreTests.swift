//
//  CodableFeedStoreTests.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 18/03/2024.
//

import XCTest
import essential_feed_case_study

final class CodableFeedStore {
    typealias RetrievalCompletion = (RetrieveCachedFeedResult) -> Void
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
}


final class CodableFeedStoreTests: XCTestCase {
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = CodableFeedStore()
        let exp = expectation(description: "Wait for retrieve completion")
        
        sut.retrieve { result in
            switch result {
            case .empty:
                break
                
            default:
                XCTFail("Expected empty result, got \(result) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieveTwice_hasNoSideEffectsOnEmptyCache() {
        let sut = CodableFeedStore()
        let exp = expectation(description: "Wait for retrieve completion")
        
        sut.retrieve { firstResult in
            // do something
            sut.retrieve { secondResult in
                // do something again
                switch (firstResult, secondResult) {
                case (.empty, .empty):
                    break
                    
                default:
                    XCTFail("Expected retrieving twice from empty cache to deliver same result, got \(firstResult) and \(secondResult) instead.")
                }
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}
