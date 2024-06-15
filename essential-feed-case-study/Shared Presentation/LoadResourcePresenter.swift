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
    public typealias Mapper = (Resource) throws -> View.ResourceViewModel
    
    private let resourceView: View
    private let errorView: ResourceErrorView
    private let loadingView: ResourceLoadingView
    private let mapper: Mapper
    
    public init(resourceView: View, loadingView: ResourceLoadingView, errorView: ResourceErrorView, mapper: @escaping Mapper) {
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
        loadingView.display(ResourceLoadingViewModel(isLoading: true)) // start loading feed
    }
    
    public func didFinishLoading(with resource: Resource) {
        do {
            resourceView.display(try mapper(resource)) // loaded feed
            loadingView.display(ResourceLoadingViewModel(isLoading: false)) // finish loading feed
        } catch {
            didFinishLoading(with: error)
        }
        
    }
    
    public func didFinishLoading(with error: Error) {
        errorView.display(ResourceErrorViewModel(message: Self.loadError))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
}
