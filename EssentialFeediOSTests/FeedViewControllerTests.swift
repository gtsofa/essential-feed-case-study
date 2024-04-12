//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Julius on 10/04/2024.
//

import XCTest
import UIKit
import essential_feed_case_study
import EssentialFeediOS

final class FeedViewControllerTests: XCTestCase {
    // test load feed actions
    func test_loadFeedActions_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        //load feed behavior
        sut.simulateAppearance() // calls viewDidLoad()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")
        
        // trigger the refreshcontrol action which happens on a .valueChanged event
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once a user initiates a load")
        
        // view is loaded only once
        // pull to refresh can be done more than once
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 3, "Expected a third loading request once a user initiates another load")
    }
    
    // test loading indicator
    func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance() // viewDidLoad
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view appears")
        
        loader.completeFeedLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once a user initiates a load")
        loader.completeFeedLoading(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading is completed")
        
    }

    
    // MARK: - Helper
    
    private func makeSUT(file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    class LoaderSpy: FeedLoader {
        private var completions = [(FeedLoader.Result) -> Void ]()
        
        var loadCallCount: Int {
            return completions.count
        }
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func completeFeedLoading(at index: Int) {
            completions[index](.success([]))
        }
    }
}

private class FakeRefreshControl: UIRefreshControl {
    private var _isRefreshing = false
    
    override var isRefreshing: Bool { _isRefreshing }
    
    override func beginRefreshing() {
        _isRefreshing = true
    }
    
    override func endRefreshing() {
        _isRefreshing = false
    }
}

//FeedViewController
private extension FeedViewController {
    
    var isShowingLoadingIndicator: Bool {
        refreshControl?.isRefreshing == true
    }
    
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    func simulateAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
            prepareForFirstAppearance()
            //replaceRefreshControlWithFakeForiOS17Support()
        }
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
    
    private func prepareForFirstAppearance() {
        setSmallFrameToPreventRenderingCells()
        replaceRefreshControlWithFakeForiOS17Support()
    }
    
    private func setSmallFrameToPreventRenderingCells() {
        tableView.frame = CGRect(x: 0, y: 0, width: 390, height: 1)
    }
    
    func replaceRefreshControlWithFakeForiOS17Support() {
        let fake = FakeRefreshControl()
        refreshControl?.allTargets.forEach{ target in
            refreshControl?.actions(forTarget: target, forControlEvent:
                    .valueChanged)?.forEach { action in
                        fake.addTarget(target, action: Selector(action), for: .valueChanged)
                    }
        }
        refreshControl = fake
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach{ target in
            actions(forTarget: target, forControlEvent:
                    .valueChanged)?.forEach {
                        (target as NSObject).perform(Selector($0))
                    }
        }
    }
}

//private class FakeRefreshControl: UIRefreshControl {
//    private var _isRefreshing = false
//    
//    override var isRefreshing: Bool {
//        _isRefreshing
//    }
//    
//    override func beginRefreshing() {
//        _isRefreshing = true
//    }
//    
//    override func endRefreshing() {
//        _isRefreshing = false
//    }
//}

//private extension FeedViewController {
//    var isShowingLoadingIndicator: Bool {
//        return refreshControl?.isRefreshing == true
//    }
//    
//    func simulateUserInitiatedFeedReload() {
//        refreshControl?.simulatePullToRefresh()
//    }
//    
//    func simulateAppearance() {
//        if !isViewLoaded {
//            loadViewIfNeeded()
//            replaceRefreshControlWithFakeForiOS17Support()
//        }
//        beginAppearanceTransition(true, animated: false)
//        endAppearanceTransition()
//    }
//    
//    func replaceRefreshControlWithFakeForiOS17Support() {
//        let fake = FakeRefreshControl()
//        refreshControl?.allTargets.forEach { target in
//            refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { action in
//                fake.addTarget(target, action: Selector(action), for: .valueChanged)
//            }
//        }
//        refreshControl = fake
//    }
//}
