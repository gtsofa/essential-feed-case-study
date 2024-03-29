//
//  FeedLoader.swift
//  essential-feed-case-study
//
//  Created by Julius on 30/01/2024.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error>

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
