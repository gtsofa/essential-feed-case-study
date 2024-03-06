//
//  CacheFeedUseCaseTests.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 06/03/2024.
//

import XCTest
import essential_feed_case_study

class LocalFeedLoader {
    let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
    
    func save(_ items: [FeedItem]) {
        //need to invoke a mtd
        store.deleteCachedFeed()
    }
}

// a helper class representing the framework side
// to help us define the abstract interface teh use case needs for
// its collaborator
//making sure we don't leak framework details into the use case
class FeedStore {
    var deleteCachedFeedCallCount = 0
    var insertCallCount = 0
    
    // mtd to be invoked in sut
    // implements the behavior we expect
    func deleteCachedFeed() {
        deleteCachedFeedCallCount += 1
    }
    
    func completeDeletion(with error: NSError, at index: Int = 0) {
        
    }
}

final class CacheFeedUseCaseTests: XCTestCase {
    // w/o invoking any behaviour
    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
    
    func test_save_requestCacheDeletion() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem(), uniqueItem()]
        
        sut.save(items)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem(), uniqueItem()]
        let deletionError = anyError()
        
        sut.save(items)
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.insertCallCount, 0)
    }
    
    // MARK: - Helpers
    
    // factory method
    private func makeSUT(file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func anyError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
    private func anyURL() -> URL {
        return URL(string: "https://any-url.com")!
    }
    
    // factory method
    // why prefer function?
    func uniqueItem() -> FeedItem {
        return FeedItem(id: UUID(), description: "any", location: "any", imageURL: anyURL())
    }

}
