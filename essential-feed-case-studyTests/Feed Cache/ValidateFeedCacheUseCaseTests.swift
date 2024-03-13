//
//  ValidateFeedCacheUseCaseTests.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 13/03/2024.
//

import XCTest
import essential_feed_case_study

final class ValidateFeedCacheUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_validateCache_deletesCacheOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        // when sut validate cache
        // i.e invoke the store with 2 mtds
        // store.retrieve completion -- 1 msg
        // store.deletecachedFeed comletion -- 2nd msg
        sut.validateCache()
        
        // we want the store to complete retrieval with
        // i.e and the store completesretrieval with an error
        store.completeRetrieval(with: anyNSError())
        
        // then the errors should be 2 msgs
        // i.e retrieve & deletecachedFeed
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }

}
