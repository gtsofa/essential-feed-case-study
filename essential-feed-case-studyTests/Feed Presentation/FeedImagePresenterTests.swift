//
//  FeedImagePresenterTests.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 03/05/2024.
//

import XCTest
import essential_feed_case_study

final class FeedImagePresenterTests: XCTestCase {
    func test_map_createsViewModel() {
        let image = uniqueImage()
        let viewModel = FeedImagePresenter.map(image)
        
        XCTAssertEqual(viewModel.description, image.description)
        XCTAssertEqual(viewModel.location, image.location )
    }
}
