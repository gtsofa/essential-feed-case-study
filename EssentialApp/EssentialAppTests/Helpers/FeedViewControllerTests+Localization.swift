//
//  FeedViewControllerTests+Localization.swift
//  EssentialFeediOSTests
//
//  Created by Julius on 30/04/2024.
//

import Foundation
import XCTest
import essential_feed_case_study

extension FeedUIIntegrationTests {
    func localized(_ key: String, file: StaticString = #filePath,
                           line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        
        if value == key {
            XCTFail("Missing localized string for key \(key)", file: file, line: line)
        }
        return value
    }
}
