//
//  LoadResourcePresenter.swift
//  essential-feed-case-study
//
//  Created by Julius on 14/06/2024.
//

import Foundation

public protocol ResourceView {
    func display(_ viewModel: String)
}
public final class LoadResourcePresenter {
    public typealias Mapper = (String) -> String
    
    private let resourceView: ResourceView
    private let errorView: FeedErrorView
    private let loadingView: FeedLoadingView
    private let mapper: Mapper
    
    public init(resourceView: ResourceView, loadingView: FeedLoadingView, errorView: FeedErrorView, mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    private var feedLoadError: String {
        return NSLocalizedString("FEED_VIEW_CONNECTION_ERROR",
                                 tableName: "Feed",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Error message displayed when we cannot load the image feed from server")
    }
    
    public func didStartLoading() {
        errorView.display(.noError) //not show errorview instead show loading spinner
        loadingView.display(FeedLoadingViewModel(isLoading: true)) // start loading feed
    }
    
    public func didFinishLoading(with resource: String) {
        resourceView.display(mapper(resource)) // loaded feed
        loadingView.display(FeedLoadingViewModel(isLoading: false)) // finish loading feed
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        errorView.display(FeedErrorViewModel(message: feedLoadError))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
