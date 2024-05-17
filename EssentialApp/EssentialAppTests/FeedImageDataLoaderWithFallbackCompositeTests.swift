//
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Julius on 16/05/2024.
//

import XCTest
import essential_feed_case_study

public final class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {
    private let primary: FeedImageDataLoader
    private struct Task: FeedImageDataLoaderTask {
        func cancel() {
            
        }
    }
    
    init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {
        self.primary = primary
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        _ = primary.loadImageData(from: url) { _ in }
        return Task()
    }
}

final class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase {
    func test_init_doesNotLoadImageData() {
        let primaryLoader = LoaderSpy()
        let fallbackLoader = LoaderSpy()
        _ = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        XCTAssertTrue(primaryLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the primary loader")
        XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
    }
    
//    func test_loadImageData_loadsFromPrimaryLoaderFirst() {
//        let url = anyURL()
//        let primaryLoader = LoaderSpy()
//        let fallbackLoader = LoaderSpy()
//        let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
//        
//        _ = sut.loadImageData(from: url) { _ in }
//        XCTAssertEqual(primaryLoader.loadedURLs, [url], "Expected to load URL from primary loader")
//        XCTAssertEqual(fallbackLoader.loadedURLs, [], "Expected no loaded URLs from fallback loader")
//    }
    
    // MARK: - Helpers
    
    private func anyURL() -> URL {
        return URL(string: "https://any-url.com")!
    }
    private class LoaderSpy: FeedImageDataLoader {
        var loadedURLs = [URL]()
        
        private struct Task: FeedImageDataLoaderTask {
            func cancel() {
            }
        }
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            return Task()
        }
    }

}
