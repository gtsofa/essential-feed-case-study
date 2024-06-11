//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Julius on 22/04/2024.
//

import UIKit
import Combine
import essential_feed_case_study
import EssentialFeediOS

public final class FeedUIComposer {
    public init() {}
    // object creation
    public static func feedComposedWith(feedLoader:  @escaping () -> AnyPublisher<[FeedImage], Error>, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) -> FeedViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(
            feedLoader: feedLoader)
        
        let feedController = makeFeedViewController(delegate: presentationAdapter, title: FeedPresenter.title)
        
        presentationAdapter.presenter = FeedPresenter(
            feedView: FeedViewAdapter(
                controller: feedController,
                imageLoader: imageLoader),
            loadingView: WeakRefVirtualProxy(feedController),
            errorView: WeakRefVirtualProxy(feedController))
        //presenter.loadingView = WeakRefVirtualProxy(refreshController)
        //resenter.feedView = FeedViewAdapter(controller: feedController, imageLoader: imageLoader)
        //on refresh -- we update the table model
        //refresh controller deletes [FeedImage]
        // we use the adapter pattern to help us compose unmatching apis
        // i.e transforms [FeedImage] -> Adapt -> [FeedImageCellController]
        
        return feedController
    }
    
    private static func makeFeedViewController(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        //let refreshController = feedController.refreshController! // set direct in storyboard
        feedController.delegate = delegate
        //eedController.refreshController = refreshController
        feedController.title = title
        
        return feedController
    }
}

