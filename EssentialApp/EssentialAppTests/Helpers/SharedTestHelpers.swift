//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Julius on 17/05/2024.
//

import Foundation
import essential_feed_case_study

func anyData() -> Data {
    return Data("any data".utf8)
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "https://a-url.com")!
}

func uniqueueFeed() -> [FeedImage] {
    return [FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())]
}
