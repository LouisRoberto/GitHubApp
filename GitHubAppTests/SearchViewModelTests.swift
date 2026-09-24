//
//  SearchViewModelTests.swift
//  GitHubAppTests
//
//  Created by mac on 18/6/25.
//

import XCTest
@testable import GitHubApp

class SearchViewModelTests: XCTestCase {
    var viewModel: SearchViewModel!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = SearchViewModel(networkService: mockNetworkService)
    }
    
    func testSuccessfulSearch() async {
        // Given
        let expectedUsers = GitHubSearchResponse.mock
        mockNetworkService.searchUsersResult = .success(expectedUsers)
        viewModel.searchQuery = "test"
        
        // When
        viewModel.searchUsers()
        
        // Then
        let predicate = NSPredicate { _, _ in
            !self.viewModel.isLoading && self.viewModel.error == nil
        }
        await fulfillment(of: [expectation(for: predicate, evaluatedWith: nil)])
        
        XCTAssertEqual(viewModel.searchResults, expectedUsers.items)
    }
    
    func testFailedSearch() async {
        // Given
        let expectedError = NSError(domain: "test", code: 500)
        mockNetworkService.searchUsersResult = .failure(expectedError)
        viewModel.searchQuery = "test"
        
        // When
        viewModel.searchUsers()
        
        // Then
        let predicate = NSPredicate { _, _ in
            !self.viewModel.isLoading
        }
        await fulfillment(of: [expectation(for: predicate, evaluatedWith: nil)])
        
        XCTAssertNotNil(viewModel.error)
        XCTAssertTrue(viewModel.searchResults.isEmpty)
    }
    
    func testEmptyQuery() {
        // Given
        viewModel.searchQuery = ""
        viewModel.searchResults = []
        
        // When
        viewModel.searchUsers()
        
        // Then
        XCTAssertTrue(viewModel.searchResults.isEmpty)
    }
}
