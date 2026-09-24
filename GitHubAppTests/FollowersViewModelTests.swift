//
//  FollowersViewModelTests.swift
//  GitHubAppTests
//
//  Created by mac on 18/6/25.
//

import XCTest
@testable import GitHubApp

class FollowersViewModelTests: XCTestCase {
    var viewModel: FollowersViewModel!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = FollowersViewModel(networkService: mockNetworkService)
    }
    
    func testSuccessfulUserFetch() async {
        // Given
        let expectedFollowers = [Follower.mock]
        mockNetworkService.fetchFollowersResult = .success(expectedFollowers)
        
        // When
        viewModel.fetchFollowers(username: "testuser", followers: true, isInitialLoad: true, totalCount: 1)
        
        // Then
        let predicate = NSPredicate { _, _ in
            !self.viewModel.isLoading && self.viewModel.error == nil
        }
        await fulfillment(of: [expectation(for: predicate, evaluatedWith: nil)])
        
        XCTAssertEqual(viewModel.followers, expectedFollowers)
    }
    
    func testFailedUserFetch() async {
        // Given
        let expectedError = NSError(domain: "test", code: 404)
        mockNetworkService.fetchFollowersResult = .failure(expectedError)
        
        // When
        viewModel.fetchFollowers(username: "nonexistent", followers: true, isInitialLoad: true, totalCount: 1)
        
        // Then
        let predicate = NSPredicate { _, _ in
            !self.viewModel.isLoading
        }
        await fulfillment(of: [expectation(for: predicate, evaluatedWith: nil)])
        
        XCTAssertNotNil(viewModel.error)
        XCTAssertTrue(viewModel.followers.isEmpty)
    }
}
