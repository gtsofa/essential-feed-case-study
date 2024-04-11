//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Julius on 10/04/2024.
//

import XCTest
import UIKit
import essential_feed_case_study

class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    private var viewAppeared = false
    //private var onViewIsAppearing: ((FeedViewController) -> Void)?
    
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        //refreshControl?.beginRefreshing()
        
        if !viewAppeared {
            refreshControl?.beginRefreshing()
            viewAppeared = true
        }
    }
    
    @objc private func load() {
        loader?.load { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
}

final class FeedViewControllerTests: XCTestCase {
    func test_init_doesNotLoadFeed() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    //load feed behavior
    func test_viewDidLoad_loadsFeed() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded() // calls viewDidLoad()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    // reload feed (pull to refresh)
    func test_userInitiatedFeedReload_loadsFeed() {
        //check reload behaviour
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        // reload feed
        // refresh logic
        // trigger the refreshcontrol action which happens on a .valueChanged event
        sut.simulateUserInitiatedFeed()
        XCTAssertEqual(loader.loadCallCount, 2)
        
        // view is loaded only once
        // pull to refresh can be done more than once
        sut.simulateUserInitiatedFeed()
        XCTAssertEqual(loader.loadCallCount, 3)
    }
    
    // show loading indicator while loading feed
    // show loading indicator - behavior
    func test_viewDidLoad_showsLoadingIndicator() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded() // viewDidLoad
        sut.replaceRefreshControlWithFakeForiOS17Support()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)//when view is loaded it's not refreshing yet
        
        // trigger 'viewIsAppearing() mtd'
        // and check refreshing is true
        //sut.viewIsAppearing(false)
        sut.beginAppearanceTransition(true, animated: false) // UIkit triggers the transitions for exampel: test when view is appearing IE it will call viewWillAppear
        sut.endAppearanceTransition() // calls viewIsAppearing + viewDidAppear
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
    }
    
    // hide loading indicator when feed loading completes
    func test_viewDidLoad_hidesLoadingIndicatorOnLoaderCompletion() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        //first load completes
        loader.completeFeedLoading()
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
    }
    
    // show loading indicator on pull to refresh
    func test_userInitiatedFeedReload_showsLoadingIndicator() {
        let (sut, _) = makeSUT()
        
        sut.simulateAppearance()
        
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
        
    }
    
    // hide loading indicator on loader completion (pull to refresh)
    func test_userInitiatedFeedReload_hidesLoadingIndicatorOnLoaderCompletion() {
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        loader.completeFeedLoading()
        
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
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
        
        func completeFeedLoading() {
            completions[0](.success([]))
        }
    }
}

extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

private extension FeedViewController {
//    var isShowingLoadingIndicator: Bool {
//        
//    }
    
    func simulateUserInitiatedFeed() {
        refreshControl?.simulatePullToRefresh()
    }
    
    func simulateAppearance() {
        if !viewAppeared {
            loadViewIfNeeded()
            replaceRefreshControlWithFakeForiOS17Support()
        }
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
    
    func replaceRefreshControlWithFakeForiOS17Support() {
        let fake = FakeRefreshControl()
        refreshControl?.allTargets.forEach { target in
            refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { action in
                fake.addTarget(target, action: Selector(action), for: .valueChanged)
            }
        }
        refreshControl = fake
    }
}

private class FakeRefreshControl: UIRefreshControl {
    private var _isRefreshing = false
    
    override var isRefreshing: Bool {
        _isRefreshing
    }
    
    override func beginRefreshing() {
        _isRefreshing = true
    }
    
    override func endRefreshing() {
        _isRefreshing = false
    }
}
