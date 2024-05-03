//
//  FeedPresenterTests.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 03/05/2024.
//

import XCTest

class FeedPresenter {
    init(view: Any) {
    }
}

final class FeedPresenterTests: XCTestCase {
    func test_init_doesNotSendMessageToView() {
        let view = ViewSpy()
        _ = FeedPresenter(view: view)
       
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK:- Helpers
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
