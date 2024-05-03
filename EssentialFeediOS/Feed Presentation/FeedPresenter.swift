//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Julius on 25/04/2024.
//

import Foundation
import essential_feed_case_study

protocol FeedLoadingView  {
    func display(_ viewModel: FeedLoadingViewModel)
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

// presenter has reference to the view through a protocol
final class FeedPresenter {
    typealias Observer<T> = (T) -> Void
    
    //replace observable properties with the feedview protocol
    private let feedView: FeedView
    private let loadingView: FeedLoadingView
    private let errorView: FeedErrorView
    
    init(feedView: FeedView, loadingView: FeedLoadingView, errorView: FeedErrorView) {
        self.feedView = feedView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE", 
                                 tableName: "Feed",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Title for the feed view")
    }
    
    private var feedLoadError: String {
        return NSLocalizedString("FEED_VIEW_CONNECTION_ERROR",
                                 tableName: "Feed",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Error message displayed when we cannot load the image feed from server")
    }
    
    func didStartLoadingFeed() {
        errorView.display(.noError) //not show errorview instead show loading spinner
        loadingView.display(FeedLoadingViewModel(isLoading: true)) // start loading feed
    }
    
    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed)) // loaded feed
        loadingView.display(FeedLoadingViewModel(isLoading: false)) // finish loading feed
    }
    
    func didFinishLoadingFeed(with error: Error) {
        errorView.display(FeedErrorViewModel(message: feedLoadError))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
