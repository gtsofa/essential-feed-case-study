//
//  FeedImageCell.swift
//  EssentialFeediOS
//
//  Created by Julius on 16/04/2024.
//

import UIKit

public final class FeedImageCell: UITableViewCell {
    // view elements
    // create instances of the view elements
    @IBOutlet private(set) public var locationContainer: UIView!
    @IBOutlet private(set) public var locationLabel: UILabel!
    @IBOutlet private(set) public var feedImageContainer: UIView!
    @IBOutlet private(set) public var feedImageView: UIImageView!
    @IBOutlet private(set) public var feedImageRetryButton: UIButton!
    @IBOutlet private(set) public var descriptionLabel: UILabel!
    
    // only the feedImageRetryButton is accessible to the outside
    // configured it on the storyboard
    
    // internal i.e not accessible to the outside
    var onRetry: (() -> Void)?
    
    @IBAction private func retryButtonTapped() {
        onRetry?()
    }
    
}
