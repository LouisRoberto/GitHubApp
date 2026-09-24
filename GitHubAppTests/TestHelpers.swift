//
//  TestHelpers.swift
//  GitHubAppTests
//
//  Created by mac on 12/5/25.
//

import Foundation
import Combine
@testable import GitHubApp

class MockNetworkService: NetworkServiceProtocol {
    
    var searchUsersResult: Result<GitHubSearchResponse, Error> = .success(GitHubSearchResponse.mock)
    var fetchUserResult: Result<User, Error> = .success(User.mock)
    var fetchFollowersResult: Result<[Follower], Error> = .success([])
    
    func fetchGitHubUsers(query: String) -> AnyPublisher<GitHubSearchResponse, Error> {
        return searchUsersResult.publisher.eraseToAnyPublisher()
    }
    
    func fetchGitHubUser(username: String) -> AnyPublisher<User, Error>{
        return fetchUserResult.publisher.eraseToAnyPublisher()
    }
    
    func fetchGitHubFollowers(username: String, followers: Bool, page: Int, perPage: Int) -> AnyPublisher<[Follower], Error> {
        return fetchFollowersResult.publisher.eraseToAnyPublisher()
    }
}

extension GitHubUser {
    static let mock = GitHubUser(
        id: 123,
        login: "testuser",
        avatarUrl: "https://avatars.githubusercontent.com/u/1668?v=4",
        url: "https://test.com/user",
        type: "User"
    )
}

extension User {
    static let mock = User(
        id: 123,
        login: "testuser",
        name: "Test User",
        avatarUrl: "https://avatars.githubusercontent.com/u/1668?v=4",
        bio: "Test bio",
        publicRepos: 10,
        followers: 100,
        following: 50
    )
}

extension GitHubSearchResponse {
    static let mock = GitHubSearchResponse(
        totalCount: 1,
        incompleteResults: false,
        items:[GitHubUser.mock]
    )
}

extension Follower {
    static let mock = Follower(
        id: 123,
        login: "testuser",
        avatarUrl: "https://avatars.githubusercontent.com/u/1668?v=4"
    )
}
