//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by Julius on 21/04/2024.
//

import Foundation

// will get cancelable in composition root; protocol 'FeedImageDataLoaderTask' goes away

public protocol FeedImageDataLoader {
    
    func loadImageData(from url: URL) throws -> Data
}
