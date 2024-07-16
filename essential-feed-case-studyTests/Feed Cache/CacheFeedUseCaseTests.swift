//
//  CacheFeedUseCaseTests.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 06/03/2024.
//

import XCTest
import essential_feed_case_study

final class CacheFeedUseCaseTests: XCTestCase {
    // w/o invoking any behaviour
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        store.completeDeletion(with: deletionError)
        
        try? sut.save(uniqueImageFeed().models)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed])
    }
    
    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
        // we need current date
        // current date is not a pure function
        // we inject it into the sut so we can control it during tests
        // i.e TEST - need a fixed date and PROD - needs a current date that was given
        let timestamp = Date()
        let (sut, store) = makeSUT(currentDate: { timestamp } )
        let feed = uniqueImageFeed()
        store.completeDeletionSuccessfully()
        
        try? sut.save(feed.models)
        
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedFeed, .insert(feed.local, timestamp)])
        
        // we need to check the values that were passed
        // timestamps need to be checked as well
//        XCTAssertEqual(store.insertions.count, 1)
        //which values were passed
//        XCTAssertEqual(store.insertions.first?.items, items)
        // check timestamps
//        XCTAssertEqual(store.insertions.first?.timestamp, timestamp)
    }
    
    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        expect(sut, toCompleteWithError: deletionError, when: {
            store.completeDeletion(with: deletionError)
        })
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        expect(sut, toCompleteWithError: insertionError, when: {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        })
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWithError: nil, when: {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        })
    }
    
    // classic example of gre
    // if you need to make calculations based on the current gregorian calendar year (e.g., 2020), then you should explicitly use the gregorian calendar.
    // Otherwise, you'll get wrong results. For instance, the current Buddhist calendar year is 2563.
    // the Gregorian calendar was commonly used for business calculations
    func test_currentYear() {
        let year = Calendar(identifier: .gregorian).component(.year, from: Date())
        
        XCTAssertEqual(year, 2024)
    }
    
    // In our case, we use the Gregorian calendar for the business rules that are agnostic of the user's preferences (it doesn't matter the user's preferred calendar
    //when calculating the cache age because, in this app, that's an internal business rule regardless of the user choices - the user doesn't even know about the cache age logic!).
    
    // MARK: - Helpers
    
    // factory method
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalFeedLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #filePath,
                        line: UInt = #line) {
        action()
        
        do {
            try sut.save(uniqueImageFeed().models)
        } catch {
            XCTAssertEqual(error as NSError?, expectedError, file: file, line: line)
        }
    }
}
