//
//  ImageComment.swift
//  essential-feed-case-study
//
//  Created by Julius on 10/06/2024.
//

import Foundation

public struct ImageComment {
    public let id: UUID
    public let message: String
    public let createdAt: Date
    public let username: String
    
    public init(id: UUID, message: String, createdAt: Date, username: String) {
        self.id = id
        self.message = message
        self.createdAt = createdAt
        self.username = username
    }
}
