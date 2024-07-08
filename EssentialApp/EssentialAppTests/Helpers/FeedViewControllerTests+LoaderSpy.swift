//
//  FeedViewControllerTests+LoaderSpy.swift
//  EssentialFeediOSTests
//
//  Created by Julius on 19/04/2024.
//

import UIKit
import EssentialFeediOS
import essential_feed_case_study
import Combine

class LoaderSpy: FeedImageDataLoader {
    // MARK: - FeedLoader
    
    private var feedRequests = [PassthroughSubject<PaginatedFeed<FeedImage>, Error>]()
    
    
    var loadFeedCallCount: Int {
        return feedRequests.count
    }
    
    func loadPublisher() -> AnyPublisher<PaginatedFeed<FeedImage>, Error> {
        let publisher = PassthroughSubject<PaginatedFeed<FeedImage>, Error>()
        feedRequests.append(publisher)
        return publisher.eraseToAnyPublisher()
    }
    
    func completeFeedLoading(with feed: [FeedImage] = [], at index: Int = 0) {
        feedRequests[index].send(PaginatedFeed(items: feed))
    }
    
    func completeFeedLoadingWithError(at index: Int = 0) {
        let error = NSError(domain: "an error", code: 0)
        feedRequests[index].send(completion: .failure(error))
    }
    
    // MARK: - FeedImageDataLoader
    
    private struct TaskSpy: FeedImageDataLoaderTask {
        let cancelCallback: () -> Void
        
        func cancel() {
            cancelCallback()
        }
    }
    
    private var imageRequests = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void) ]()
    
    // loaderspy is capturing loadedimageurls
    var loadedImageURLs: [URL] {
        return imageRequests.map {$0.url}
    }
    
    //spy is capturing cancelledimageURLs
    private(set) var cancelledImageURLs = [URL]()
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        imageRequests.append((url, completion))
        return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url)}
    }
    
    func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
        imageRequests[index].completion(.success(imageData))
    }
    
    func completeImageLoadingWithError(at index: Int = 0) {
        let error = NSError(domain: "an error", code: 0)
        imageRequests[index].completion(.failure(error))
    }
}
