//
//  UserViewModel.swift
//  GitHubApp
//
//  Created by Naoufal on 10/5/25.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var error: NetworkError?
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    private let apiClient: APIClientProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        self.apiClient = APIClient()
    }
    
    func fetchUser(username: String) {
        isLoading = true
        error = nil
        
        networkService.fetchGitHubUser(username: username)
            .sink(receiveCompletion: { [weak self] completion in
            self?.isLoading = false
            if case .failure(let error) = completion {
                self?.error = NetworkError.map(error)
            }
        }, receiveValue: { [weak self] user in
            self?.user = user
        })
        .store(in: &cancellables)
    }
    
    @MainActor
    func retrieveUser(username: String) async{
        isLoading = true
        error = nil
        do {
            async let userTask = apiClient.fetchGitHubUser(username: username)
            let userResult = try await userTask
            isLoading = false
            self.user = userResult
        } catch {
            isLoading = false
            self.error = NetworkError.map(error)
        }
    }
}
