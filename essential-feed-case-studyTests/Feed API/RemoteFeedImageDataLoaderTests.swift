//
//  RemoteFeedImageDataLoaderTests.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 07/05/2024.
//

import XCTest

class RemoteFeedImageDataLoader {
    init(client: Any) {}
}

final class RemoteFeedImageDataLoaderTests: XCTestCase {
    func test_init_doesNotPerformAnyURLRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    // MARK:- Helper function
    
    private func makeSUT(url: URL = anyURL(), file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: RemoteFeedImageDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, client)
    }
    
    private class HTTPClientSpy {
        let requestedURLs = [URL]()
    }

}
