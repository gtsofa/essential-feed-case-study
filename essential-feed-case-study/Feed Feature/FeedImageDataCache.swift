//
//  FeedImageDataCache.swift
//  essential-feed-case-study
//
//  Created by Julius on 19/05/2024.
//

import Foundation

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
