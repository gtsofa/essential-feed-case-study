//
//  SharedTestHelpers.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 13/03/2024.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "https://any-url.com")!
}
