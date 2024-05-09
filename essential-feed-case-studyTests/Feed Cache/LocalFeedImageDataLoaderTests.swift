//
//  LocalFeedImageDataLoaderTests.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 09/05/2024.
//

import XCTest
import essential_feed_case_study

protocol FeedImageDataStore {
    func retrieve(dataForURL url: URL)
}

class LocalFeedImageDataLoader: FeedImageDataLoader {
    private struct Task: FeedImageDataLoaderTask {
        func cancel() {}
    }
    
    private let store: FeedImageDataStore
    
    init(store: FeedImageDataStore) {
        self.store = store
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        //pass msg `retrieve(dataForURL: url)` to the store
        store.retrieve(dataForURL: url)
        return Task()
    }
}

final class LocalFeedImageDataLoaderTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMsgs.isEmpty)
    }
    
    func test_loadImageDataFromURL_requestsStoredDataForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(store.receivedMsgs, [.retrieve(dataFor: url)])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: StoreSpy) {
        let store = StoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private class StoreSpy: FeedImageDataStore {
        enum Message: Equatable {
            case retrieve(dataFor: URL)
        }
        
        private(set) var receivedMsgs = [Message]()
        
        var requestedURLs = [URL]()
        
        func retrieve(dataForURL url: URL) {
            //capture msgs for use in our test
            receivedMsgs.append(.retrieve(dataFor: url))
            
        }
        
    }

}
