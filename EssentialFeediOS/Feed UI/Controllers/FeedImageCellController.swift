//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Julius on 22/04/2024.
//

import UIKit
import essential_feed_case_study

final class FeedImageCellController {
    // create a task
    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    //create a view for this controller
    func view() -> UITableViewCell {
        let cell = FeedImageCell() // create a cell
        //configure the cell with the model
        cell.locationContainer.isHidden = (model.location == nil) // location container is hidden when data.location==nil
        cell.locationLabel.text = model.location// location text is data.location
        cell.descriptionLabel.text = model.description // location text is data.description
        //set image to nil before start loading
        cell.feedImageView.image = nil
        //control state for the retrybutton
        cell.feedImageRetryButton.isHidden = true
        cell.feedImageContainer.startShimmering() // start shimmering before loading the image
        // store a task for a given indexpath
        // we need a callback to receive the results and stop shimmering
        // internal closure for to include the onRetry logic
        let loadImage = { [weak self, weak cell] in
            guard let self = self else { return }
            
            //keep state of running task
            self.task = self.imageLoader.loadImageData(from: model.url) { [weak cell] result in
                let data = try? result.get()
                let image = data.map(UIImage.init) ?? nil // convert/map from 'data' to 'uiimage' or else set it to nil(fail to convert)
                cell?.feedImageView.image = image
                cell?.feedImageRetryButton.isHidden = (image != nil) // if there is image show button
                cell?.feedImageContainer.stopShimmering()
            } // keep track of the state now
        }
        
        cell.onRetry = loadImage
        loadImage()
        
        return cell
    }
    
    func preload() {
        task = imageLoader.loadImageData(from: model.url) { _ in }
    }
    
    func cancelLoad() {
        task?.cancel()
    }
}
