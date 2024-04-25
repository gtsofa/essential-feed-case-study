//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Julius on 25/04/2024.
//

import Foundation
import essential_feed_case_study

protocol FeedLoadingView: class  {
    func display(isLoading: Bool)
}

protocol FeedView {
    func display(feed: [FeedImage])
}

// presenter has reference to the view through a protocol
final class FeedPresenter {
    typealias Observer<T> = (T) -> Void
    
    private let feedLoader: FeedLoader

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    //replace observable properties with the feedview protocol
    var feedView: FeedView?
    weak var loadingView: FeedLoadingView?

    func loadFeed() {
        loadingView?.display(isLoading: true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(feed: feed)
            }
            self?.loadingView?.display(isLoading: false)
        }
    }
}
