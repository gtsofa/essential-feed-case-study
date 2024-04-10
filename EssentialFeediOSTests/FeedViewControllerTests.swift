//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Julius on 10/04/2024.
//

import XCTest
import UIKit

class FeedViewController: UIViewController {
    private var loader: FeedViewControllerTests.LoaderSpy?
    
    convenience init(loader: FeedViewControllerTests.LoaderSpy) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // invoke a method i.e to pass a message
        loader?.load()
        
    }
}

final class FeedViewControllerTests: XCTestCase {
    // load feed when view is presented
    func test_init_doesNotLoadFeedWhenViewIsNotPresented() {
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader) // create feedvc with a loader
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    // we are not testing the viewdidload mtd
    // BUT we are testing what our implementation does when viewDidLoad mtd is called by UIKit
    func test_viewDidLoad_loadsFeed() {
        let loader = LoaderSpy()
        
        let sut = FeedViewController(loader: loader)
        
        sut.loadViewIfNeeded() // tell feedvc to load its view
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    
    // MARK: - Helpers
    
    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
        
        func load() {
            loadCallCount += 1
        }
    }
}
