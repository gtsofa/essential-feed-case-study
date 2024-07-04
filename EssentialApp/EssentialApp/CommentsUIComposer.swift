//
//  CommentsUIComposer.swift
//  EssentialApp
//
//  Created by Julius on 04/07/2024.
//

import UIKit
import Combine
import essential_feed_case_study
import EssentialFeediOS

public final class CommentsUIComposer {
    public init() {}
    
    private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>
    // object creation
    public static func commentsComposedWith(
        commentsLoader:  @escaping () -> AnyPublisher<[FeedImage], Error>
    ) -> ListViewController {
            
        let presentationAdapter = FeedPresentationAdapter(loader: commentsLoader)
        
        let feedController = makeFeedViewController(title: FeedPresenter.title)
        feedController.onRefresh = presentationAdapter.loadResource
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                controller: feedController,
                imageLoader: {_ in Empty<Data, Error>().eraseToAnyPublisher() }),
            loadingView: WeakRefVirtualProxy(feedController),
            errorView: WeakRefVirtualProxy(feedController),
            mapper: FeedPresenter.map)
        //presenter.loadingView = WeakRefVirtualProxy(refreshController)
        //resenter.feedView = FeedViewAdapter(controller: feedController, imageLoader: imageLoader)
        //on refresh -- we update the table model
        //refresh controller deletes [FeedImage]
        // we use the adapter pattern to help us compose unmatching apis
        // i.e transforms [FeedImage] -> Adapt -> [FeedImageCellController]
        
        return feedController
    }
    
    private static func makeFeedViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! ListViewController
        //let refreshController = feedController.refreshController! // set direct in storyboard
        //eedController.refreshController = refreshController
        feedController.title = title
        
        return feedController
    }
}
