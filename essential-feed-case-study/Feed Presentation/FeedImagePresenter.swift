//
//  FeedImagePresenter.swift
//  essential-feed-case-study
//
//  Created by Julius on 05/05/2024.
//

import Foundation

public final class FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(
            description: image.description,
            location: image.location
        )
    }
}
