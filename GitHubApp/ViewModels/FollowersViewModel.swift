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
    private var currentPage = 1
    private let perPage = 30
    
    private let networkService: NetworkServiceProtocol
    private let apiClient: APIClientProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        self.apiClient = APIClient()
    }
    
    @MainActor
    func refreshFollowers(username: String, followers: Bool, totalCount: Int) async {
        currentPage = 1
        await retrieveFollowers(username: username, followers: followers, isInitialLoad: true, totalCount: totalCount)
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
    
    @MainActor
    func retrieveFollowers(username: String, followers: Bool, isInitialLoad: Bool = true, totalCount: Int) async {
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
        
        do {
            let fetchedFollowers = try await apiClient.fetchGitHubFollowers(username: username, followers: followers, page: currentPage, perPage: perPage)
            
            // Clear loading state based on load type (matches sink receiveCompletion)
            if isInitialLoad {
                isLoading = false
            } else {
                isLoadingMore = false
            }
            
            // Append or replace (matches receiveValue)
            if isInitialLoad {
                self.followers = fetchedFollowers
            } else {
                self.followers += fetchedFollowers
            }
            
            // Increment page if more data is available
            if self.followers.count < totalCount {
                self.currentPage += 1
            }
        } catch {
            if isInitialLoad {
                isLoading = false
            } else {
                isLoadingMore = false
            }
            
            self.error = NetworkError.map(error)
            
            if isInitialLoad {
                self.followers = []
            }
        }
    }
}
