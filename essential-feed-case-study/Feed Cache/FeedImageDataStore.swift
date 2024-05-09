//
//  FeedImageDataStore.swift
//  essential-feed-case-study
//
//  Created by Julius on 09/05/2024.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
