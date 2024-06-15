//
//  FeedPresenterTests.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 03/05/2024.
//

import XCTest
import essential_feed_case_study

final class FeedPresenterTests: XCTestCase {
    func test_title_isLocalized() {
        XCTAssertEqual(FeedPresenter.title, localized("FEED_VIEW_TITLE"))
    }
    
    func test_map_createsViewModels() {
        let feed = uniqueImageFeed().models
        let viewModel = FeedPresenter.map(feed)
        
        XCTAssertEqual(viewModel.feed, feed)
    }
    
    // MARK:- Helpers
    
    private func localized(_ key: String, table: String = "Feed", file: StaticString = #filePath,
                           line: UInt = #line) -> String {
        let bundle = Bundle(for: FeedPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        
        if value == key {
            XCTFail("Missing localized string for key \(key)", file: file, line: line)
        }
        return value
    }
}
