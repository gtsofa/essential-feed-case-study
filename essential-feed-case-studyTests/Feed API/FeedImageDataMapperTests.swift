//
//  FeedImageDataMapperTests.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 12/06/2024.
//

import XCTest
import essential_feed_case_study

final class FeedImageDataMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let samples = [199, 201, 300, 400, 500]
        
        try samples.enumerated().forEach { index, code in
            XCTAssertThrowsError(
                try FeedImageDataMapper.map(anyData(), from: HTTPURLResponse(statusCode: code))
            )
        }
    }
}
