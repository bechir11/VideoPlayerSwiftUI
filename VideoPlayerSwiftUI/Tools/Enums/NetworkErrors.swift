//
//  NetworkErrors.swift
//  VideoPlayerSwiftUI
//
//  Created by Bechir Belkahla on 17/6/2024.
//

import Foundation

enum NetworkErrors: Error {
    case invalidURL
    case invalidResponse
    case requestFailed
    case decodingError
}

extension NetworkErrors {
    var localized: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid Response"
        case .requestFailed:
            return "Request Failed"
        case .decodingError:
            return "Decoding Error"
        }
    }
}
