//
//  FeedLocalizationTests.swift
//  EssentialFeediOSTests
//
//  Created by Julius on 30/04/2024.
//

import XCTest
import essential_feed_case_study

final class FeedLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}
