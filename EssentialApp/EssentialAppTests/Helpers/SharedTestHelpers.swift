//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Julius on 17/05/2024.
//

import Foundation

func anyData() -> Data {
    return Data("any data".utf8)
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "https://a-url.com")!
}
