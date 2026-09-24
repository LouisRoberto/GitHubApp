//
//  SearchViewModel.swift
//  GitHubApp
//
//  Created by Naoufal on 10/5/25.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchResults: [GitHubUser] = []
    @Published var isLoading = false
    @Published var error: NetworkError?
    @Published var searchQuery = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    private var debounceTimer: Timer?
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func searchUsers() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.performSearch()
        }
    }
    
    private func performSearch() {
        guard !searchQuery.isEmpty else {
            searchResults = []
            return
        }
        isLoading = true
        error = nil
        
        networkService.fetchGitHubUsers(query: searchQuery)
            .sink(receiveCompletion: { [weak self] completion in
            self?.isLoading = false
            if case .failure(let error) = completion {
                self?.error = NetworkError.map(error)
            }
        }, receiveValue: { [weak self] users in
            self?.searchResults = users.items.filter { $0.login.lowercased().contains(self?.searchQuery.lowercased() ?? "") }
        })
        .store(in: &cancellables)
    }
}
