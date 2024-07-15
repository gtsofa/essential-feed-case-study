//
//  FeedImageDataStore.swift
//  essential-feed-case-study
//
//  Created by Julius on 09/05/2024.
//

import Foundation

public protocol FeedImageDataStore {
    
    func retrieve(dataForURL url: URL) throws -> Data?
    func insert(_ data: Data, for url: URL) throws
}

