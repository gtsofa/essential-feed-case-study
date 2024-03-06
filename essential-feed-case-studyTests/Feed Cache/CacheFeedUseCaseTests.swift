//
//  CacheFeedUseCaseTests.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 06/03/2024.
//

import XCTest

class LocalFeedLoader {
    let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
}

// a helper class representing the framework side
// to help us define the abstract interface teh use case needs for
// its collaborator
//making sure we don't leak framework details into the use case
class FeedStore {
    var deleteCachedFeedCallCount = 0
}

final class CacheFeedUseCaseTests: XCTestCase {
    //w/o invoking any behaviour
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }

}
