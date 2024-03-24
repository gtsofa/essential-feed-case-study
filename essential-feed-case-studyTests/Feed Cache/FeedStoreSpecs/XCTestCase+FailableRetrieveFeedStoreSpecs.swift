//
//  XCTestCase+FailableRetrieveFeedStoreSpecs.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 24/03/2024.
//

import XCTest
import essential_feed_case_study

extension FailableRetrieveFeedStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDleiversFailureOnRetrievalError(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        // retrieve
        expect(sut, toRetrieve: .failure(anyNSError()), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnFailure(on sut: FeedStore, file: StaticString = #file, line: UInt = #line) {
        // retrieve twice does not delete the invalid data
        // that's not the job for the codableFeedstore
        expect(sut, toRetrieveTwice: .failure(anyNSError()), file: file, line: line)
    }

}
