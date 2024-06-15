//
//  FeedPresenter.swift
//  essential-feed-case-study
//
//  Created by Julius on 03/05/2024.
//

import Foundation

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

public class FeedPresenter {
    public static var title: String {
        NSLocalizedString("FEED_VIEW_TITLE",
                          tableName: "Feed",
                          bundle: Bundle(for: FeedPresenter.self),
                          comment: "Title for the feed view")
    }
    
    public static func map(_ feed: [FeedImage]) -> FeedViewModel {
        FeedViewModel(feed: feed)
    }
}
