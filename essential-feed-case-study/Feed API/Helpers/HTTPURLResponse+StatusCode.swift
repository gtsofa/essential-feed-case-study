//
//  HTTPURLResponse+StatusCode.swift
//  essential-feed-case-study
//
//  Created by Julius on 08/05/2024.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
