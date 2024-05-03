//
//  FeedPresenter.swift
//  essential-feed-case-study
//
//  Created by Julius on 03/05/2024.
//

import Foundation

public struct FeedErrorViewModel {
    public let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

public protocol FeedLoadingView  {
    func display(_ viewModel: FeedLoadingViewModel)
}

public struct FeedLoadingViewModel {
    public let isLoading: Bool
}

public protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

public class FeedPresenter {
    private let feedView: FeedView
    private let errorView: FeedErrorView
    private let loadingView: FeedLoadingView
    
    public init(feedView: FeedView, loadingView: FeedLoadingView, errorView: FeedErrorView) {
        self.feedView = feedView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    public static var title: String {
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
    
    public func didStartLoadingFeed() {
        errorView.display(.noError) //not show errorview instead show loading spinner
        loadingView.display(FeedLoadingViewModel(isLoading: true)) // start loading feed
    }
    
    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed)) // loaded feed
        loadingView.display(FeedLoadingViewModel(isLoading: false)) // finish loading feed
    }
    
    public func didFinishLoadingFeed(with error: NSError) {
        errorView.display(FeedErrorViewModel(message: feedLoadError))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
