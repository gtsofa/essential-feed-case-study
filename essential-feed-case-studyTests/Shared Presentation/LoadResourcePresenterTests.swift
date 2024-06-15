//
//  LoadResourcePresenterTests.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 14/06/2024.
//

import XCTest
import essential_feed_case_study

final class LoadResourcePresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessageToView() {
        let(_, view) = makeSUT()
       
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoading_displaysNoErrorMessageAndStartsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoading()
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: .none),
            .display(isLoading: true)
        ])
    }
    
    func test_didFinishLoadingResource_displaysResourceAndStopLoading() {
        let (sut, view) = makeSUT(mapper: { resource in
            resource + " view model"
        })
        
        sut.didFinishLoading(with: "resource")
        
        XCTAssertEqual(view.messages, [
            .display(resourceViewModel: "resource view model"),
            .display(isLoading: false)
        ])
    }
    
    func test_didFinishLoadingResourceWithError_displaysLocalizedErrorMessageAndStopsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didFinishLoading(with: anyNSError())
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: localized("GENERIC_VIEW_CONNECTION_ERROR")),
            .display(isLoading: false)])
    }
    
    // MARK:- Helpers
    private typealias SUT = LoadResourcePresenter<String, ViewSpy>
    
    private func makeSUT(
        mapper: @escaping SUT.Mapper = { _ in "any"},
        file: StaticString = #filePath,
        line: UInt = #line) -> (sut: SUT, view: ViewSpy) {
            let view = ViewSpy()
            let sut = SUT(resourceView: view, loadingView: view, errorView: view, mapper: mapper)
            trackForMemoryLeaks(view, file: file, line: line)
            trackForMemoryLeaks(sut, file: file, line: line)
            
            return (sut, view)
        }
    
    private func localized(_ key: String, file: StaticString = #filePath,
                           line: UInt = #line) -> String {
        let table = "Shared"
        let bundle = Bundle(for: SUT.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        
        if value == key {
            XCTFail("Missing localized string for key \(key)", file: file, line: line)
        }
        return value
    }
    
    private class ViewSpy: ResourceView, FeedLoadingView, FeedErrorView {
        typealias ResourceViewModel = String
        
        enum Message:Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
            case display(resourceViewModel: String)
            //case display(error: String)
        }
        
        private(set) var messages = Set<Message>()
        
        func display(_ viewModel: FeedErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }
        
        func display(_ viewModel: FeedLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: String) {
            messages.insert(.display(resourceViewModel: viewModel))
        }
    }

}
