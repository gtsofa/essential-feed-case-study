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
    public let locationContainer = UIView()
    public let locationLabel = UILabel()
    public let descriptionLabel = UILabel()
    public let feedImageContainer = UIView()
    public let feedImageView = UIImageView()
    //public let feedImageRetryButton = UIButton()
    
    // only the feedImageRetryButton is accessible to the outside
    private(set) public lazy var feedImageRetryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // internal i.e not accessible to the outside
    var onRetry: (() -> Void)?
    
    @objc private func retryButtonTapped() {
        onRetry?()
    }
    
}
