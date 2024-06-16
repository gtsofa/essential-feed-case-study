//
//  ImageCommentsLocalizationTests.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 16/06/2024.
//

import XCTest
import essential_feed_case_study

final class ImageCommentsLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}
