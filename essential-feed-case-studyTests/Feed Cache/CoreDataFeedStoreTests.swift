//
//  CoreDataFeedStoreTests.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 25/03/2024.
//

import XCTest
import essential_feed_case_study

final class CoreDataFeedStoreTests: XCTestCase, FeedStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyCache() throws {
        try makeSUT { sut in
            self.assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
        }
    
    }
    
    func test_retrieveTwice_hasNoSideEffectsOnEmptyCache() throws {
        try makeSUT {sut in
            self.assertThatRetrieveTwiceHasNoSideEffectsOnEmptyCache(on: sut)
        }
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() throws {
        try makeSUT {sut in
            self.assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
        }
        
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() throws {
        try makeSUT {sut in
            self.assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
        }
    }

    func test_insert_deliversNoErrorOnEmptyCache() throws {
        try makeSUT {sut in
            self.assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
        }
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() throws {
        try makeSUT {sut in
            self.assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
        }
        
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() throws {
        try makeSUT { sut in
            self.assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
        }
        
    }
    
    func test_delete_deliversNoErrorOnEmtpyCache() throws {
        try makeSUT {sut in
            self.assertThatDeleteDeliversNoErrorOnEmtpyCache(on: sut)
        }
    }
    
    func test_delete_hasNoSideEffectsOnEmtpyCache() throws {
        try makeSUT { sut in
            self.assertThatDeleteHasNoSideEffectsOnEmtpyCache(on: sut)
        }
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() throws {
        try makeSUT {sut in
            self.assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
        }
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() throws {
        try makeSUT {sut in
            self.assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
        }
        
    }
    
    // MARK: - Helpers
    
    private func makeSUT(_ test: @escaping (CoreDataFeedStore) -> Void, file: StaticString = #filePath, line: UInt = #line) throws {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try CoreDataFeedStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        let exp = expectation(description: "wait for operation")
        sut.perform {
            test(sut)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }

}
