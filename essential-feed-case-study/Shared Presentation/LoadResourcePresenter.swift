//
//  LoadResourcePresenter.swift
//  essential-feed-case-study
//
//  Created by Julius on 14/06/2024.
//

import Foundation

public protocol ResourceView {
    associatedtype ResourceViewModel
    
    func display(_ viewModel: ResourceViewModel)
}

public final class LoadResourcePresenter<Resource, View: ResourceView> {
    public typealias Mapper = (Resource) -> View.ResourceViewModel
    
    private let resourceView: View
    private let errorView: FeedErrorView
    private let loadingView: FeedLoadingView
    private let mapper: Mapper
    
    public init(resourceView: View, loadingView: FeedLoadingView, errorView: FeedErrorView, mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    public static var loadError: String {
        return NSLocalizedString("GENERIC_VIEW_CONNECTION_ERROR",
                                 tableName: "Shared",
                                 bundle: Bundle(for: LoadResourcePresenter.self),
                                 comment: "Error message displayed when we cannot load the resource from server")
    }
    
    public func didStartLoading() {
        errorView.display(.noError) //not show errorview instead show loading spinner
        loadingView.display(FeedLoadingViewModel(isLoading: true)) // start loading feed
    }
    
    public func didFinishLoading(with resource: Resource) {
        resourceView.display(mapper(resource)) // loaded feed
        loadingView.display(FeedLoadingViewModel(isLoading: false)) // finish loading feed
    }
    
    public func didFinishLoading(with error: Error) {
        errorView.display(FeedErrorViewModel(message: Self.loadError))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
