//
//  FeedLoader.swift
//  essential-feed-case-study
//
//  Created by Julius on 30/01/2024.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: (LoadFeedResult) -> Void)
}
