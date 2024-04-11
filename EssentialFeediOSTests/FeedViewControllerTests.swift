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
    
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // trigger the load
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    @objc func load() {
        // invoke a method i.e to pass a message
        loader?.load() { _ in }
    }
}

final class FeedViewControllerTests: XCTestCase {
    // load feed when view is presented
    func test_init_doesNotLoadFeedWhenViewIsNotPresented() {
        let (_, loader) = makeSUT() // create feedvc with a loader
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    // we are not testing the viewdidload mtd
    // BUT we are testing what our implementation does when viewDidLoad mtd is called by UIKit
    func test_viewDidLoad_loadsFeed() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded() // tell feedvc to load its view
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    // manually reload feed (pull to refresh)
    func test_pullToRefresh_reloadsFeed() {
        // reloads view
        
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        //sut.relaods view?
        // Do not test framework by scrolling the scroll view
        // We want to trigger the refreshControl action which happens on .valueChange event
        sut.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(loader.loadCallCount, 2)
        
        // try pull to refresh more than once
        // since a view can be loaded only once but pull to refresh can be done multiple times
        sut.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(loader.loadCallCount, 3)
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    class LoaderSpy: FeedLoader {
        private(set) var loadCallCount: Int = 0
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            loadCallCount += 1
        }
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            sut.refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
