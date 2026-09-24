//
//  User.swift
//  GitHubApp
//
//  Created by Naoufal on 10/5/25.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    let id: Int
    let login: String
    let name: String?
    let avatarUrl: String
    let bio: String?
    let publicRepos: Int
    let followers: Int
    let following: Int
    
    enum CodingKeys: String, CodingKey {
        case id, login, name, bio
        case avatarUrl = "avatar_url"
        case publicRepos = "public_repos"
        case followers, following
    }
}
