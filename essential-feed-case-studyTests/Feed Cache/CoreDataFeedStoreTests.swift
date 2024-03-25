//
//  CoreDataFeedStoreTests.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 25/03/2024.
//

import XCTest

final class CoreDataFeedStoreTests: XCTestCase {
    func test_retrieve_deliversEmptyOnEmptyCache() {}
    
    func test_retrieveTwice_hasNoSideEffectsOnEmptyCache() {}
    
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

}
