//
//  URLSessionHTTPClient.swift
//  essential-feed-case-studyTests
//
//  Created by Julius on 20/02/2024.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnExpectedValueRepresentation: Error {}
    
    private struct URLSessionTaskWrapper: HTTPClientTask {
        let wrapped: URLSessionTask
        
        func cancel() {
            wrapped.cancel()
        }
    }
    
    public  func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        // we should be testing the behaviour here not every interaction of the URLSession
        let task = session.dataTask(with: url) { data, response, error in
            completion(Result {
                if let error = error {
                    throw error
                } else if let data = data, let response = response as? HTTPURLResponse {
                    return (data, response)
                } else {
                    throw UnExpectedValueRepresentation()
                }
            })
           
        }
        task.resume()
        return URLSessionTaskWrapper(wrapped: task)
    }
}
