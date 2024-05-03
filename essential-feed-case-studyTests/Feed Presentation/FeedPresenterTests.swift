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
        let(_, view) = makeSUT()
       
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK:- Helpers
    
    private func makeSUT(file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(view: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, view)
    }
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
