//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Julius on 23/04/2024.
//

import Foundation
import essential_feed_case_study

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    

    var hasLocation: Bool {
        return location != nil
    }
}
