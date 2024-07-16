//
//  FeedCache.swift
//  essential-feed-case-study
//
//  Created by Julius on 18/05/2024.
//

import Foundation

public protocol FeedCache {
    func save(_ feed: [FeedImage]) throws
}
