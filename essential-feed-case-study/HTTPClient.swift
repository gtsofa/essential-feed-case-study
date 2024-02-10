//
//  HTTPClient.swift
//  essential-feed-case-study
//
//  Created by Julius on 10/02/2024.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping(HTTPClientResult) -> Void )
}
