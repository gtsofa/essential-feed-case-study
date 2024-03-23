//
//  CodableFeedStoreTests.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 18/03/2024.
//

import XCTest
import essential_feed_case_study

final class CodableFeedStoreTests: XCTestCase, FailableFeedStoreSpecs {
    override func tearDown() {
        super.tearDown()
        undoStoreSideEffects()
    }
    
    override func setUp() {
        super.setUp()
        setupEmptyStoreState()
        
    }
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
    
        expect(sut, toRetrieve: .empty)
    }
    
    func test_retrieveTwice_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieveTwice: .empty)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        let sut = makeSUT()
        
        //insert
        insert((feed, timestamp), to: sut)
        
        //retrieve
        expect(sut, toRetrieve: .found(feed: feed, timestamp: timestamp))
        
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        //insert something in cache
        // retrieve twice
        insert((feed, timestamp), to: sut)
        
        expect(sut, toRetrieveTwice: .found(feed: feed, timestamp: timestamp))
    }
    
    func test_retrieve_dleiversFailureOnRetrievalError() {
        //insert something
        //try to retrieve it and get an error
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        // try to insert invalid data to a URL
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        // retrieve
        expect(sut, toRetrieve: .failure(anyNSError()))
        
    }
    
    func test_retrieve_hasNoSideEffectsOnFailure() {
        //insert something
        //try to retrieve it and get an error
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        // try to insert invalid data to a URL
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        // retrieve twice does not delete the invalid data
        // that's not the job for the codableFeedstore
        expect(sut, toRetrieveTwice: .failure(anyNSError()))
        
    }
    //To non-empty cache overrides previous data with new data
    func test_insert_deliversNoErrorOnEmptyCache() {
        //first insert
        //second insert should override the first insert
        let sut = makeSUT()
        
        let insertionError = insert((uniqueImageFeed().local, Date()), to: sut)
        XCTAssertNil(insertionError, "Expected to insert cache successfully")
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {
        //first insert
        //second insert should override the first insert
        let sut = makeSUT()
        
        insert((uniqueImageFeed().local, Date()), to: sut)
       
        let insertionError = insert((uniqueImageFeed().local, Date()), to: sut)
        XCTAssertNil(insertionError, "Expected to override cache successfully")
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {
        //first insert
        //second insert should override the first insert
        let sut = makeSUT()
        
        insert((uniqueImageFeed().local, Date()), to: sut)
        
        let latestFeed = uniqueImageFeed().local
        let latestTimestamp = Date()
        insert((latestFeed, latestTimestamp), to: sut)
        
        expect(sut, toRetrieve: .found(feed: latestFeed, timestamp: latestTimestamp))
    }
    
    //Insert - Error (if applicable, e.g., no write permission)
    func test_insert_deliversErrorOnInsertionError() {
        //try to insert into invalid store url
        let invalidStoreURL = URL(string: "invalid://store-url")!
        //let invalidStoreURL = URL(string: "invalid://store-url")
        let sut = makeSUT(storeURL: invalidStoreURL)
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        let insertionError = insert((feed, timestamp), to: sut)
        
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error")
    }
    
    func test_insert_hasNoSideEffectsOnInsertionError() {
        //try to insert into invalid store url
        let invalidStoreURL = URL(string: "invalid://store-url")!
        //let invalidStoreURL = URL(string: "invalid://store-url")
        let sut = makeSUT(storeURL: invalidStoreURL)
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)
        
        expect(sut, toRetrieve: .empty)
    }
    
    // DELETE specs
    func test_delete_hasNoSideEffectsOnEmtpyCache() {
        //delete the cache
        //check there is no error
        let sut = makeSUT()
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed")
        expect(sut, toRetrieve: .empty)
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {
        //insert
        //then delete should leave cache empty
        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        sut.insert(feed, timestamp: timestamp) { insertionError in
            XCTAssertNil(insertionError, "Expected cache insertion successfully")
        }
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
        //insert
        //then delete should leave cache empty
        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        sut.insert(feed, timestamp: timestamp) { insertionError in
            XCTAssertNil(insertionError, "Expected cache insertion successfully")
        }
        
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_delete_deliversErrorOnDeletionError() {
        //try delete from a url that we do not have permission
        //eg the system folder that we cannot delete
        let sut = makeSUT(storeURL: noDeletePermissionURL())
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNotNil(deletionError, "Expected cache deletion to fail")
        expect(sut, toRetrieve: .empty)
    }
    
    func test_delete_hasNoSideEffectsOnDeletionError() {
        //try delete from a url that we do not have permission
        //eg the system folder that we cannot delete
        let sut = makeSUT(storeURL: noDeletePermissionURL())
        
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()
        //insert..delete..insert
        var completeOperationsInOrder = [XCTestExpectation]()
        
        let op1 = expectation(description: "Operation 1")
        sut.insert(uniqueImageFeed().local, timestamp: Date()) { _ in
            completeOperationsInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Operation 2")
        sut.deleteCachedFeed { _ in
            completeOperationsInOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "Operation 3")
        sut.insert(uniqueImageFeed().local, timestamp: Date()) { _ in
            completeOperationsInOrder.append(op3)
            op3.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
        XCTAssertEqual(completeOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(storeURL: URL? = nil,  file: StaticString = #filePath,
                         line: UInt = #line) -> FeedStore {
        
        let sut = CodableFeedStore(storeURL: storeURL ?? testSpecificStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
        
    }
    
    private func noDeletePermissionURL() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .systemDomainMask).first!
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        //return FileManager.default.urls(for: .cachesDirectory, in: .systemDomainMask).first!
    }
}
