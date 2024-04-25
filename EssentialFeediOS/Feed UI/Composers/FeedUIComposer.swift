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
        let presenter = FeedPresenter(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(presenter: presenter)
        let feedController = FeedViewController(refreshController: refreshController)
        presenter.loadingView = refreshController
        presenter.feedView = FeedViewAdapter(controller: feedController, imageLoader: imageLoader)
        //on refresh -- we update the table model
        //refresh controller deletes [FeedImage]
        // we use the adapter pattern to help us compose unmatching apis
        // i.e transforms [FeedImage] -> Adapt -> [FeedImageCellController]
        
        return feedController
    }
    
    private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
        return { [weak controller] feed in
            //map feedimages to cellcontrollers
            // feedvc expects [FeedImageCellController]
            controller?.tableModel = feed.map { model in
                FeedImageCellController(viewModel: FeedImageViewModel(model: model, imageLoader: loader, imageTransformer: UIImage.init))
            }
        }
    }
}

private final class FeedViewAdapter: FeedView {
    private weak var controller: FeedViewController?
    private let imageLoader: FeedImageDataLoader
    
    init(controller: FeedViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(feed: [FeedImage]) {
        //map feedimages to cellcontrollers
        // feedvc expects [FeedImageCellController]
        controller?.tableModel = feed.map { model in
            FeedImageCellController(viewModel: FeedImageViewModel(model: model, imageLoader: imageLoader, imageTransformer: UIImage.init))
        }
    }
}
