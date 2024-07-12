//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Julius on 01/05/2024.
//

import Foundation
import UIKit
import essential_feed_case_study
import EssentialFeediOS

final class FeedViewAdapter: ResourceView {
    private weak var controller: ListViewController?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    private typealias ImageDataPresentationAdapter = LoadResourcePresentationAdapter<Data, WeakRefVirtualProxy<FeedImageCellController>>
    
    private typealias LoadMorePresentationAdapter = LoadResourcePresentationAdapter<Paginated<FeedImage>, FeedViewAdapter>
    
    private let selection: (FeedImage) -> Void
    //dictionary ie lookup table
    private let currentFeed: [FeedImage: CellController]
    
    init(currentFeed: [FeedImage: CellController] = [:], controller: ListViewController, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher, selection: @escaping (FeedImage) -> Void) {
        self.currentFeed = currentFeed
        self.controller = controller
        self.imageLoader = imageLoader
        self.selection = selection
    }
    
    func display(_ viewModel: Paginated<FeedImage>) {
        // no controller cannot load a page
        guard let controller = controller else {return }
        //need to populate it
        var currentFeed = self.currentFeed
        //map feedimages to cellcontrollers
        // feedvc expects [FeedImageCellController]
        let feed: [CellController] = viewModel.items.map { model in
            //look up for the given model if we have a value for it; no need to recreate it
            if let controller = currentFeed[model] {
                return controller
            }
            
            let adapter = ImageDataPresentationAdapter(loader: { [imageLoader] in
                
                imageLoader(model.url)
            })
            
            let view = FeedImageCellController(
                viewModel: FeedImagePresenter.map(model),
                delegate: adapter,
                selection: { [selection] in
                    selection(model)
                })
            
            adapter.presenter = LoadResourcePresenter(
                resourceView: WeakRefVirtualProxy(view),
                loadingView: WeakRefVirtualProxy(view),
                errorView: WeakRefVirtualProxy(view),
                mapper: UIImage.tryMake)
            
            let controller = CellController(id: model, view)
            currentFeed[model] = controller
            return controller
        }
        
        guard let loadMorePublisher = viewModel.loadMorePublisher else {
            controller.display(feed)
            return 
        }
        // in case confusing worth to re-watch live#002
        let loadMoreAdapter = LoadMorePresentationAdapter(loader: loadMorePublisher)
        
        // here we need to 'create' a new 'section' into the cell controllers
        // now here we should use the adapter 'loadResource' method instead of calling 'loadMore' every time
        // because the 'loadResource' in the adapter is the one that we will call the 'loadMorePublisher' and handle all the state transitions with the presenter
        let loadMore = LoadMoreCellController(callback: loadMoreAdapter.loadResource)
        
        loadMoreAdapter.presenter = LoadResourcePresenter(
            //pass forward the currentfeed
            resourceView: FeedViewAdapter(
                currentFeed: currentFeed,
                controller: controller,
                imageLoader: imageLoader,
                selection: selection
            ),
            loadingView: WeakRefVirtualProxy(loadMore),
            errorView: WeakRefVirtualProxy(loadMore),
            mapper: { $0 })
        
        let loadMoreSection = [CellController(id: UUID(), loadMore)]
        
        controller.display(feed, loadMoreSection)
    }
}

final class CommentsViewAdapter: ResourceView {
    private weak var controller: ListViewController?
    
    init(controller: ListViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: ImageCommentsViewModel) {
        controller?.display(viewModel.comments.map { viewModel in
            CellController(id: viewModel, ImageCommentCellController(model: viewModel))
        })
    }
}

extension UIImage {
    struct InvalidImageData: Error {}
    
    static func tryMake(data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw InvalidImageData()
        }
        return image
    }
}
