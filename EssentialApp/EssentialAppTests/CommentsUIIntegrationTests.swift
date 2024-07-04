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
    override func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance() // viewDidLoad
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view appears")
        
        loader.completeFeedLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")
        
        sut.simulateUserInitiatedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once a user initiates a load")
        
        loader.completeFeedLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes with error")
        
    }
    
    override func test_loadFeedCompletion_rendersSuccessfullyLoadedFeed() {
        // create feed image (location, description, imageURL)
        // we want to render a cell for a given model
        // a create a model
        let image0 = makeImage(description: "a description", location: "a location")
        let image1 = makeImage(description: nil, location: "another location")
        let image2 = makeImage(description: "another description", location: nil)
        let image3 = makeImage(description: nil, location: nil)
        let (sut, loader) = makeSUT()
        //when
        ///  0 case
        sut.simulateAppearance()//loadViewIfNeeded()
        //no images are rendered yet
       // XCTAssertEqual(sut.numberOfRenderedFeedImageViews(), 0)
        assertThat(sut, isRendering: [])
        
        // loader completes loading 1 image
        /// 1 element
        loader.completeFeedLoading(with: [image0], at: 0)
        //XCTAssertEqual(sut.numberOfRenderedFeedImageViews(), 1)
        //assertThat(sut, hasViewConfiguredFor: image0, at: 0)
        assertThat(sut, isRendering: [image0])

        
        // everytime you test collection; test: 1)zero case 2) 1 element case 3)many elements case
        /// many element case
        sut.simulateUserInitiatedReload()
        loader.completeFeedLoading(with: [image0, image1, image2, image3], at: 1)
        assertThat(sut, isRendering: [image0, image1, image2, image3])
        
        // check count
        // check the values pattern :)
        
    }
    
    override func test_loadFeedCompletion_rendersSuccessfullyLoadedEmptyFeedAfterNonEmptyFeed() {
        //we dont care about values in this test
        let image0 = makeImage()
        let image1 = makeImage()
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()//loadViewIfNeeded()
        loader.completeFeedLoading(with: [image0, image1], at: 0)
        assertThat(sut, isRendering: [image0, image1])

        //if load again but we receive empty array of images
        // it should not crash instead it should render an empty feed
        sut.simulateUserInitiatedReload()
        loader.completeFeedLoading(with: [], at: 1)
        assertThat(sut, isRendering: [])
    }
    
    override func test_loadFeedCompletion_doesNotAlterCurrentRenderingStateOnError() {
        // load images
        // complete loading success
        //user initiate a reload
        // load complete loading with failure //failed - Expected 1 images, got 0 instead
        
        let image0 = makeImage(description: "a description", location: "a location")
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        loader.completeFeedLoading(with: [image0], at: 0)
        assertThat(sut, isRendering: [image0])
        
        sut.simulateUserInitiatedReload()
        loader.completeFeedLoadingWithError(at: 1)
        assertThat(sut, isRendering: [image0])
        
    }
    
    // dispatch FeedLoader results to the MainThread
    override func test_loadFeedCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.simulateAppearance()
        
        let exp = expectation(description: "Wait for background queue")
        // make it complete loading in the global queue
        DispatchQueue.global().async {
            loader.completeFeedLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    override func test_loadFeedCompletion_rendersErrorMessageOnErrorUntilNextReload() {
        let(sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        
        XCTAssertEqual(sut.errorMessage, nil)
        
        loader.completeFeedLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, loadError)
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(sut.errorMessage, nil)
    }
    
    override func test_tapOnErrorView_hidesErrorMessage() {
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        XCTAssertEqual(sut.errorMessage, nil)
        
        loader.completeFeedLoadingWithError(at: 0)
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
    
    private func makeImage(description: String? = nil, location: String? = nil, url: URL = URL(string: "http://any-url.com")!) -> FeedImage {
        return FeedImage(id: UUID(), description: description, location: location, url: url)
    }
    
    class LoaderSpy {
        private var requests = [PassthroughSubject<[FeedImage], Error>]()
        
        
        var loadCommentsCallCount: Int {
            return requests.count
        }
        
        func loadPublisher() -> AnyPublisher<[FeedImage], Error> {
            let publisher = PassthroughSubject<[FeedImage], Error>()
            requests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func completeFeedLoading(with feed: [FeedImage] = [], at index: Int = 0) {
            requests[index].send(feed)
        }
        
        func completeFeedLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            requests[index].send(completion: .failure(error))
        }
    }

}
