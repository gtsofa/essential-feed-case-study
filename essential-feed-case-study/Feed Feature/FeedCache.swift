//
//  FeedCache.swift
//  essential-feed-case-study
//
//  Created by Julius on 18/05/2024.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
