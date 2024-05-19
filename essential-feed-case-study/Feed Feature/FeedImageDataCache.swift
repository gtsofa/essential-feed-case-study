//
//  FeedImageDataCache.swift
//  essential-feed-case-study
//
//  Created by Julius on 19/05/2024.
//

import Foundation

public protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Swift.Error>
    
    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
