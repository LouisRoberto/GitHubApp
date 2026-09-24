//
//  Follower.swift
//  GitHubApp
//
//  Created by Naoufal on 10/5/25.
//

import Foundation

struct Follower: Codable, Identifiable, Equatable {
    let id: Int
    let login: String
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, login
        case avatarUrl = "avatar_url"
    }
}
