//
//  FollowersViewModel.swift
//  GitHubApp
//
//  Created by Naoufal on 10/5/25.
//

import Foundation
import Combine

class FollowersViewModel: ObservableObject {
    @Published var followers: [Follower] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var error: NetworkError?
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    private var currentPage = 1
    private let perPage = 30
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func refreshFollowers(username: String, followers: Bool, totalCount: Int) {
        currentPage = 1
        fetchFollowers(username: username, followers: followers, isInitialLoad: true, totalCount: totalCount)
    }
    
    func fetchFollowers(username: String, followers: Bool, isInitialLoad: Bool = true, totalCount: Int) {
        
        if !isInitialLoad && self.followers.count >= totalCount {
            return
        }
        
        if isInitialLoad {
            isLoading = true
            currentPage = 1
        } else {
            isLoadingMore = true
        }
        
        error = nil
        
        networkService.fetchGitHubFollowers(username: username, followers: followers,  page: currentPage, perPage: perPage)
            .sink(receiveCompletion: { [weak self] completion in
                if isInitialLoad {
                    self?.isLoading = false
                } else {
                    self?.isLoadingMore = false
                }
                if case .failure(let error) = completion {
                    self?.error = NetworkError.map(error)
                    if isInitialLoad {
                        self?.followers = []
                    }
                }
            }, receiveValue: { [weak self] followers in
                
                if isInitialLoad {
                    self?.followers = followers
                } else {
                    self?.followers += followers
                }
                
                if self?.followers.count ?? 0 < totalCount {
                    self?.currentPage += 1
                }
            })
            .store(in: &cancellables)
    }
}
