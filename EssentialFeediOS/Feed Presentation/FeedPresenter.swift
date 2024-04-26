//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Julius on 25/04/2024.
//

import Foundation
import essential_feed_case_study

struct FeedLoadingViewModel {
    let isLoading: Bool
}

protocol FeedLoadingView  {
    func display(_ viewModel: FeedLoadingViewModel)
}

struct FeedViewModel {
    let feed: [FeedImage]
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

// presenter has reference to the view through a protocol
final class FeedPresenter {
    typealias Observer<T> = (T) -> Void
    
    //replace observable properties with the feedview protocol
    var feedView: FeedView?
    var loadingView: FeedLoadingView?
    
    func didStartLoadingFeed() {
        loadingView?.display(FeedLoadingViewModel(isLoading: true)) // start loading feed
    }
    
    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView?.display(FeedViewModel(feed: feed)) // loaded feed
        loadingView?.display(FeedLoadingViewModel(isLoading: false)) // finish loading feed
    }
    
    func didFinishLoadingFeed(with error: Error) {
        loadingView?.display(FeedLoadingViewModel(isLoading: false))
    }
}
