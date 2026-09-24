//
//  APIClient.swift
//  GitHubApp
//
//  Created by mac on 24/9/26.
//

import Foundation

protocol APIClientProtocol {
    func fetchGitHubUsers(query: String) async throws -> GitHubSearchResponse
    func fetchGitHubUser(username: String) async throws -> User
    func fetchGitHubFollowers(username: String, followers: Bool, page: Int, perPage: Int) async throws -> [Follower]
}

class APIClient: APIClientProtocol {
    
    static let shared = APIClient()
    private let session: URLSessionProtocol
    private let cache = NSCache<NSString, NSData>()
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchGitHubUsers(query: String) async throws -> GitHubSearchResponse {
        let url = URL(string: GitHubAPI.searchQueryEndpoint + query)!
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode(GitHubSearchResponse.self, from: data)
    }
    
    func fetchGitHubUser(username: String) async throws -> User {
        let cacheKey = NSString(string: "user_\(username)")
        
        if let cachedData = cache.object(forKey: cacheKey) as Data? {
            return try JSONDecoder().decode(User.self, from: cachedData)
        }
        
        let url = URL(string: GitHubAPI.searchEndpoint + username)!
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(User.self, from: data)
    }
    
    func fetchGitHubFollowers(username: String, followers: Bool, page: Int, perPage: Int) async throws -> [Follower] {
        let path = followers ? "/followers" : "/following"
        let url = URL(string: GitHubAPI.searchEndpoint + username + path + "?page=\(page)&per_page=\(perPage)")!
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode([Follower].self, from: data)
    }
}
