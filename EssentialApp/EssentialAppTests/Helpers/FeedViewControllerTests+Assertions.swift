//
//  FeedViewControllerTests+Assertions.swift
//  EssentialFeediOSTests
//
//  Created by Julius on 19/04/2024.
//

import XCTest
import essential_feed_case_study
import EssentialFeediOS

extension FeedUIIntegrationTests {
    func assertThat(_ sut: ListViewController, isRendering feed: [FeedImage], file: StaticString = #filePath, line: UInt = #line) {
        sut.view.enforceLayoutCycle() // force table view to layout
        
        guard sut.numberOfRenderedFeedImageViews() == feed.count else {
            return XCTFail("Expected \(feed.count) images, got \(sut.numberOfRenderedFeedImageViews()) instead", file: file, line: line)
        }
        
        feed.enumerated().forEach { index, image in
            assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
        }
    }
    
    func assertThat(_ sut: ListViewController, hasViewConfiguredFor image: FeedImage, at index: Int, file: StaticString = #filePath,
                            line: UInt = #line) {
        let view = sut.feedImageView(at: index)
        // view is of FeedImageCell type
        guard let cell = view as? FeedImageCell else {
            return XCTFail("Expected \(FeedImageCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        let shouldLocationBeVisible = (image.location != nil)
        XCTAssertEqual(cell.isShowingLocation, shouldLocationBeVisible, "Expected 'isShowingLocation' to be \(shouldLocationBeVisible) for image view at index (\(index))", file: file, line: line) //should be showing the location koz we gave it a location. i.e either show/hid location
        XCTAssertEqual(cell.locationText, image.location, "Expected location text to be \(String(describing: image.location)) for image view at index (\(index))", file: file, line: line) // location text should be same as image location text
        XCTAssertEqual(cell.descriptionText, image.description, "Expected location text to be \(String(describing: image.description)) for image view at index (\(index))", file: file, line: line) //description text should be same as image description text
    }
}
