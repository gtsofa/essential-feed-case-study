//
//  RemoteFeedLoader.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 30/01/2024.
//

import XCTest

class RemoteFeedLoader {
    func load() {}
}

class HTTPClient {
    var requestedURL: URL?
}

final class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }

}
