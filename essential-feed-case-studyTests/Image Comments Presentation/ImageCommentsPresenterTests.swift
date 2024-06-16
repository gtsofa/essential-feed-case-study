//
//  ImageCommentsPresenterTests.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 16/06/2024.
//

import XCTest
import essential_feed_case_study

final class ImageCommentsPresenterTests: XCTestCase {
    func test_title_isLocalized() {
        XCTAssertEqual(ImageCommentsPresenter.title, localized("IMAGE_COMMENTS_VIEW_TITLE"))
    }
    
//    func test_map_createsViewModels() {
//        let feed = uniqueImageFeed().models
//        let viewModel = FeedPresenter.map(feed)
//        
//        XCTAssertEqual(viewModel.feed, feed)
//    }
    
    // MARK:- Helpers
    
    private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        
        if value == key {
            XCTFail("Missing localized string for key \(key)", file: file, line: line)
        }
        return value
    }

}
