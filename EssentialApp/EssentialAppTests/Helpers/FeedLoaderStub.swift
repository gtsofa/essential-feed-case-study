//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Julius on 18/05/2024.
//

import Foundation
import essential_feed_case_study

class FeedLoaderStub: FeedLoader {
    private let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
        self.result = result
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
    
}
