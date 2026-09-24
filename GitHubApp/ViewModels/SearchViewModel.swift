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
    private var debounceTimer: Timer?
    
    private let networkService: NetworkServiceProtocol
    private let apiClient: APIClientProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        self.apiClient = APIClient()
    }
    
    func searchUsers() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) {_ in 
            Task { [weak self] in
                guard let self else { return }
                await self.excuteSearch()
            }
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
    
    @MainActor
    func excuteSearch() async {
        guard !searchQuery.isEmpty else {
            searchResults = []
            return
        }
        isLoading = true
        error = nil
        
        do {
            async let searchTask = apiClient.fetchGitHubUsers(query: searchQuery)
            let searchResult = try await searchTask
            isLoading = false
            self.searchResults = searchResult.items
        } catch {
            isLoading = false
            self.error = NetworkError.map(error)
        }
    }
}
