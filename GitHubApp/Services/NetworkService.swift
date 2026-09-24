//
//  NetworkService.swift
//  GitHubApp
//
//  Created by Naoufal on 10/5/25.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func fetchGitHubUsers(query: String) -> AnyPublisher<GitHubSearchResponse, Error>
    func fetchGitHubUser(username: String) -> AnyPublisher<User, Error>
    func fetchGitHubFollowers(username: String, followers: Bool, page: Int, perPage: Int) -> AnyPublisher<[Follower], Error>
}

class NetworkService: NetworkServiceProtocol {
    
    public let cache = NSCache<NSString, NSData>()
    
    func fetchGitHubUsers(query: String) -> AnyPublisher<GitHubSearchResponse, Error> {
        let url = URL(string: GitHubAPI.searchQueryEndpoint + query)!
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: GitHubSearchResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchGitHubUser(username: String) -> AnyPublisher<User, Error> {
        //Adding cache only to user
        let cacheKey = NSString(string: "user_\(username)")
        
        if let cachedData = cache.object(forKey: cacheKey) as Data? {
            return Just(cachedData)
                .decode(type: User.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        
        let url = URL(string: GitHubAPI.searchEndpoint + username)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: User.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchGitHubFollowers(username: String, followers: Bool, page: Int = 1, perPage: Int = 30) -> AnyPublisher<[Follower], Error> {
        //Using same function to retrieve the list of Followings & Followers
        let path = followers ? "/followers" : "/following"
        let url = URL(string: GitHubAPI.searchEndpoint + username + path + "?page=\(page)&per_page=\(perPage)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Follower].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}
