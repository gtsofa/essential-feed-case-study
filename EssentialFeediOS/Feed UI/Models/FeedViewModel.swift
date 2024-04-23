//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Julius on 23/04/2024.
//

import Foundation
import essential_feed_case_study

final class FeedViewModel {
    typealias Observer<T> = (T) -> Void
    
    private let feedLoader: FeedLoader

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    //closure for loading state change
    var onLoadingStateChange: Observer<Bool>?
    // notifying new versions of the feed
    var onFeedLoad: Observer<[FeedImage]>?


    func loadFeed() {
        onLoadingStateChange?(true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}
