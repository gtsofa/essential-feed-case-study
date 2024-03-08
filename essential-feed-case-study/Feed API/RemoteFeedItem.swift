//
//  RemoteFeedItem.swift
//  essential-feed-case-study
//
//  Created by Julius on 08/03/2024.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
