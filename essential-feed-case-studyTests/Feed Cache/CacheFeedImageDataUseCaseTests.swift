//
//  CacheFeedImageDataUseCaseTests.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 10/05/2024.
//

import XCTest
import essential_feed_case_study

final class CacheFeedImageDataUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMsgs.isEmpty)
    }
    
    func test_saveImageDataForURL_requestImageInsertionForURL() {
        let (sut, store) = makeSUT()
        let data = anyData()
        let url = anyURL()
        
        try? sut.save(data, for: url)
        
        XCTAssertEqual(store.receivedMsgs, [.insert(data: data, for: url)])
    }
    
    func test_saveImageDataFromURL_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: failed(), when: {
            let insertionError = anyNSError()
            store.completeInsertion(with: insertionError)
        })
    }
    
    func test_saveImageDataFromURL_succeedsOnSuccessfullyStoreInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success(()), when: {
            store.completeInsertionSuccessfully()
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: FeedImageDataStoreSpy) {
        let store = FeedImageDataStoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func failed() -> Result<Void, Error> {
        return .failure(LocalFeedImageDataLoader.SaveError.failed)
    }
    
    private func expect(_ sut: LocalFeedImageDataLoader, toCompleteWith expectedResult: Result<Void, Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        action()
        
        let receivedResult = Result { try sut.save(anyData(), for: anyURL())}
        
        switch (receivedResult, expectedResult) {
        case (.success, .success):
            break
            
        case (.failure(let receivedError as LocalFeedImageDataLoader.SaveError), .failure(let expectedError as LocalFeedImageDataLoader.SaveError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        default:
            XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
        exp.fulfill()
        
        wait(for: [exp], timeout: 1.0)
    }
}
