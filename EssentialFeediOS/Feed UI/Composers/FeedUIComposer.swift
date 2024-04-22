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
        let refreshController = FeedRefreshViewController(feedLoader: feedLoader)
        let feedController = FeedViewController(refreshController: refreshController)
        //on refresh -- we update the table model
        refreshController.onRefresh = { [weak feedController] feed in
            //map feedimages to cellcontrollers
            feedController?.tableModel = feed.map { model in
                FeedImageCellController(model: model, imageLoader: imageLoader)
            }
        }
        
        return feedController
    }
}
