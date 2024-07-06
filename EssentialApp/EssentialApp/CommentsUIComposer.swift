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
    
    private typealias CommentsPresentationAdapter = LoadResourcePresentationAdapter<[ImageComment], CommentsViewAdapter>
    // object creation
    public static func commentsComposedWith(
        commentsLoader:  @escaping () -> AnyPublisher<[ImageComment], Error>
    ) -> ListViewController {
            
        let presentationAdapter = CommentsPresentationAdapter(loader: commentsLoader)
        
        let commentsController = makeCommentsViewController(title: ImageCommentsPresenter.title)
        commentsController.onRefresh = presentationAdapter.loadResource
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: CommentsViewAdapter(controller: commentsController),
            loadingView: WeakRefVirtualProxy(commentsController),
            errorView: WeakRefVirtualProxy(commentsController),
            mapper: { ImageCommentsPresenter.map($0) })
        //presenter.loadingView = WeakRefVirtualProxy(refreshController)
        //resenter.feedView = FeedViewAdapter(controller: feedController, imageLoader: imageLoader)
        //on refresh -- we update the table model
        //refresh controller deletes [FeedImage]
        // we use the adapter pattern to help us compose unmatching apis
        // i.e transforms [FeedImage] -> Adapt -> [FeedImageCellController]
        
        return commentsController
    }
    
    private static func makeCommentsViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! ListViewController
        //let refreshController = feedController.refreshController! // set direct in storyboard
        //eedController.refreshController = refreshController
        controller.title = title
        
        return controller
    }
}
