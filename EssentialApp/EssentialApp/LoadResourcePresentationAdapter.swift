//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Julius on 01/05/2024.
//

import Combine
import essential_feed_case_study
import EssentialFeediOS

final class LoadResourcePresentationAdapter<Resource, View: ResourceView> {
    var presenter: LoadResourcePresenter<Resource, View>?
    
    private let loader: () -> AnyPublisher<Resource, Error>
    private var cancellable: Cancellable?
    var isLoading = false
    
    init(loader: @escaping () -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }
    
    //where all the states are managed
    func loadResource() {
        guard !isLoading else { return }
        presenter?.didStartLoading()
        //when loading
        isLoading = true
        
        cancellable = loader()
            .dispatchOnMainQueue()
            .handleEvents(receiveCancel: { [weak self] in 
                self?.isLoading = false
            })
            .sink(
            receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: break
                    
                case let .failure(error):
                    self?.presenter?.didFinishLoading(with: error)
                }
                //completes loading
                self?.isLoading = false
            }, receiveValue: { [weak self] resource in
                self?.presenter?.didFinishLoading(with: resource)
            })
    }
}

extension LoadResourcePresentationAdapter: FeedImageCellControllerDelegate {
    func didRequestImage() {
        loadResource()
    }
    
    func didCancelImageRequest() {
        cancellable?.cancel()
        cancellable = nil
    }
    
}

