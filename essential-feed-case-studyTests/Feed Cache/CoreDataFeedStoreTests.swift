//
//  CoreDataFeedStoreTests.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 25/03/2024.
//

import XCTest
import essential_feed_case_study

final class CoreDataFeedStoreTests: XCTestCase, FeedStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
    
        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }
    
    func test_retrieveTwice_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveTwiceHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {}
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {}

    func test_insert_deliversNoErrorOnEmptyCache() {}
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {}
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {}
    
    func test_delete_deliversNoErrorOnEmtpyCache() {}
    
    func test_delete_hasNoSideEffectsOnEmtpyCache() {}
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {}
    
    func test_delete_emptiesPreviouslyInsertedCache() {}
    
    func test_storeSideEffects_runSerially() {}
    
    // MARK: - Helpers
    
    private func makeSUT(storeURL: URL? = nil, file: StaticString = #filePath,
                         line: UInt = #line) -> FeedStore {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let sut = try! CoreDataFeedStore(bundle: storeBundle)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

}
