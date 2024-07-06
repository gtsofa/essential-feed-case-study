//
//  FeedEndpointTests.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 06/07/2024.
//
import XCTest
import essential_feed_case_study

final class FeedEndpointTests: XCTestCase {
    func test_feed_endpointURL() {
        let baseURL = URL(string: "https://base-url.com")!
        
        let received = FeedEndpoint.get.url(baseURL: baseURL)
        let expected = URL(string: "https://base-url.com/v1/feed")!
        
        XCTAssertEqual(received, expected)
    }
}
