//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Julius on 22/04/2024.
//

import UIKit
import essential_feed_case_study

public final class FeedUIComposer {
    public init() {}
    // object creation
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        //we have compositions of the types ie. refreshcontroller + feedimagecellcontroler
        let feedViewModel = FeedViewModel(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(viewModel: feedViewModel)
        let feedController = FeedViewController(refreshController: refreshController)
        //on refresh -- we update the table model
        //refresh controller deletes [FeedImage]
        // we use the adapter pattern to help us compose unmatching apis
        // i.e transforms [FeedImage] -> Adapt -> [FeedImageCellController]
        feedViewModel.onFeedLoad = adaptFeedToCellControllers(forwardingTo: feedController, loader: imageLoader)
        
        return feedController
    }
    
    private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
        return { [weak controller] feed in
            //map feedimages to cellcontrollers
            // feedvc expects [FeedImageCellController]
            controller?.tableModel = feed.map { model in
                FeedImageCellController(viewModel: FeedImageViewModel(model: model, imageLoader: loader))
            }
        }
    }
}
