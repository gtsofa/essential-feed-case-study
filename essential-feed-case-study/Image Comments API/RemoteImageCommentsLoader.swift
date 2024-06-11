//
//  RemoteImageCommentsLoader.swift
//  essential-feed-case-study
//
//  Created by Julius on 10/06/2024.
//

import Foundation

public typealias RemoteImageCommentsLoader = RemoteLoader<[ImageComment]>

public extension RemoteImageCommentsLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: ImageCommentsMapper.map)
    }
}
