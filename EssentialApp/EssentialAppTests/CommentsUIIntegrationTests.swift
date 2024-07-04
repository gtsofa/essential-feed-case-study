//
//  CommentsUIIntegrationTests.swift
//  EssentialAppTests
//
//  Created by Julius on 04/07/2024.
//

import XCTest
import UIKit
import Combine
import EssentialApp
import essential_feed_case_study
import EssentialFeediOS

final class CommentsUIIntegrationTests: FeedUIIntegrationTests {
    func test_commentsView_hasTitle() {
        let (sut, _) = makeSUT()
        
        sut.simulateAppearance()
        
        XCTAssertEqual(sut.title, commentsTitle)
    }
    
    // test load feed actions
    func test_loadCommentsActions_requestCommentsFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCommentsCallCount, 0, "Expected no loading requests before view is loaded")
        
        //load feed behavior
        sut.simulateAppearance() // calls viewDidLoad()
        XCTAssertEqual(loader.loadCommentsCallCount, 1, "Expected a loading request once view is loaded")
        
        // trigger the refreshcontrol action which happens on a .valueChanged event
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadCommentsCallCount, 2, "Expected another loading request once a user initiates a load")
        
        // view is loaded only once
        // pull to refresh can be done more than once
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadCommentsCallCount, 3, "Expected a third loading request once a user initiates another load")
    }
    
    // test loading indicator
    func test_loadingCommentsIndicator_isVisibleWhileLoadingComments() {
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance() // viewDidLoad
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view appears")
        
        loader.completeCommentsLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")
        
        sut.simulateUserInitiatedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once a user initiates a load")
        
        loader.completeCommentsLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
        
    }
    
    func test_loadCommentsCompletion_rendersSuccessfullyLoadedComments() {
        // create feed image (location, description, imageURL)
        // we want to render a cell for a given model
        // a create a model
        let comment0 = makeComment(message: "a message", username: "a username")
        let comment1 = makeComment(message: "another message", username: "another username")
        
        let (sut, loader) = makeSUT()
        //when
        ///  0 case
        sut.simulateAppearance()//loadViewIfNeeded()
        //no images are rendered yet
       // XCTAssertEqual(sut.numberOfRenderedFeedImageViews(), 0)
        assertThat(sut, isRendering: [ImageComment]())
        
        // loader completes loading 1 image
        /// 1 element
        loader.completeCommentsLoading(with: [comment0], at: 0)
        //XCTAssertEqual(sut.numberOfRenderedFeedImageViews(), 1)
        //assertThat(sut, hasViewConfiguredFor: image0, at: 0)
        assertThat(sut, isRendering: [comment0])

        
        // everytime you test collection; test: 1)zero case 2) 1 element case 3)many elements case
        /// many element case
        sut.simulateUserInitiatedReload()
        loader.completeCommentsLoading(with: [comment0, comment1], at: 1)
        assertThat(sut, isRendering: [comment0, comment1])
        
        // check count
        // check the values pattern :)
        
    }
    
    func test_loadCommentsCompletion_rendersSuccessfullyLoadedEmptyCommentAfterNonEmptyComments() {
        //we dont care about values in this test
        let comment0 = makeComment()
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()//loadViewIfNeeded()
        loader.completeCommentsLoading(with: [comment0], at: 0)
        assertThat(sut, isRendering: [comment0])

        //if load again but we receive empty array of images
        // it should not crash instead it should render an empty feed
        sut.simulateUserInitiatedReload()
        loader.completeCommentsLoading(with: [], at: 1)
        assertThat(sut, isRendering: [ImageComment]())
    }
    
    func test_loadCommentsCompletion_doesNotAlterCurrentRenderingStateOnError() {
        // load images
        // complete loading success
        //user initiate a reload
        // load complete loading with failure //failed - Expected 1 images, got 0 instead
        
        let comment0 = makeComment(message: "a description", username: "a location")
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        loader.completeCommentsLoading(with: [comment0], at: 0)
        assertThat(sut, isRendering: [comment0])
        
        sut.simulateUserInitiatedReload()
        loader.completeCommentsLoadingWithError(at: 1)
        assertThat(sut, isRendering: [comment0])
        
    }
    
    // dispatch FeedLoader results to the MainThread
    override func test_loadFeedCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.simulateAppearance()
        
        let exp = expectation(description: "Wait for background queue")
        // make it complete loading in the global queue
        DispatchQueue.global().async {
            loader.completeCommentsLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    override func test_loadFeedCompletion_rendersErrorMessageOnErrorUntilNextReload() {
        let(sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        
        XCTAssertEqual(sut.errorMessage, nil)
        
        loader.completeCommentsLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, loadError)
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(sut.errorMessage, nil)
    }
    
    override func test_tapOnErrorView_hidesErrorMessage() {
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        XCTAssertEqual(sut.errorMessage, nil)
        
        loader.completeCommentsLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, loadError)
        
        sut.simulateErrorViewTap()
        XCTAssertEqual(sut.errorMessage, nil)
    }
   
    
    override func test_loadFeedActions_runsAutomaticallyOnlyOnFirstAppearance() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCommentsCallCount, 0, "Expected no loading requests before view appears")
        
        sut.simulateAppearance()
        XCTAssertEqual(loader.loadCommentsCallCount, 1, "Expected a loading request once view appears")
        
        sut.simulateAppearance()
        XCTAssertEqual(loader.loadCommentsCallCount, 1, "Expected no loading request the second time view appears")
    }

    
    // MARK: - Helper
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: ListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = CommentsUIComposer.commentsComposedWith(commentsLoader: loader.loadPublisher)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func assertThat(_ sut: ListViewController, isRendering comments: [ImageComment], file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(sut.numberOfRenderedComments(), comments.count, "comment count", file: file, line: line)
        
        let viewModel = ImageCommentsPresenter.map(comments)
        
        viewModel.comments.enumerated().forEach { index, comment in
            XCTAssertEqual(sut.commentMessage(at: index), comment.message, "message at \(index)", file: file, line: line)
            XCTAssertEqual(sut.commentDate(at: index), comment.date, "date at \(index)", file: file, line: line)
            XCTAssertEqual(sut.commentUsername(at: index), comment.username, "username at \(index)", file: file, line: line)
        }
    }
    
    private func makeComment(message: String = "a message", username: String = "any username") -> ImageComment {
        return ImageComment(id: UUID(), message: message, createdAt: Date(), username: username)
    }
    
    class LoaderSpy {
        private var requests = [PassthroughSubject<[ImageComment], Error>]()
        
        
        var loadCommentsCallCount: Int {
            return requests.count
        }
        
        func loadPublisher() -> AnyPublisher<[ImageComment], Error> {
            let publisher = PassthroughSubject<[ImageComment], Error>()
            requests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func completeCommentsLoading(with comments: [ImageComment] = [], at index: Int = 0) {
            requests[index].send(comments)
        }
        
        func completeCommentsLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            requests[index].send(completion: .failure(error))
        }
    }

}
