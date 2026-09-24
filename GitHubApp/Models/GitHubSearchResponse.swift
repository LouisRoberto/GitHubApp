//
//  GitHubSearchResponse.swift
//  GitHubApp
//
//  Created by Naoufal on 10/5/25.
//

import Foundation

struct GitHubSearchResponse: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [GitHubUser]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

struct GitHubUser: Codable, Hashable, Identifiable {
    let id: Int
    let login: String
    let avatarUrl: String
    let url: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case id, login, url, type
        case avatarUrl = "avatar_url"
    }
}
