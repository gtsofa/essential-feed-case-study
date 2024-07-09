//
//  FeedEndpoint.swift
//  essential-feed-case-study
//
//  Created by Julius on 06/07/2024.
//

import Foundation

public enum FeedEndpoint {
    case get
    // if you're creating a library don't use optional URL
    // if it's just a module then use option so when client pass a wrong url its a programmer error
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            //let url = baseURL.appendingPathComponent("v1/feed")
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/v1/feed"
            components.queryItems = [
                URLQueryItem(name: "limit", value: "10")
            ]
            
            return components.url!
        }
    }
}
