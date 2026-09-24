//
//  URLSessionProtocol.swift
//  GitHubApp
//
//  Created by mac on 24/9/26.
//

import Foundation

// Protocol to make URLSession mockable for testing
protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
    func data(from url: URL) async throws -> (Data, URLResponse)
}

// Make the standard URLSession conform to our protocol
extension URLSession: URLSessionProtocol {}
