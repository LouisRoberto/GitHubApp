//
//  UserViewModelTests.swift
//  GitHubAppTests
//
//  Created by mac on 18/6/25.
//

import XCTest
@testable import GitHubApp

class UserViewModelTests: XCTestCase {
    var viewModel: UserViewModel!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = UserViewModel(networkService: mockNetworkService)
    }
    
    func testSuccessfulUserFetch() async {
        // Given
        let expectedUser = User.mock
        mockNetworkService.fetchUserResult = .success(expectedUser)
        
        // When
        viewModel.fetchUser(username: "testuser")
        
        // Then
        let predicate = NSPredicate { _, _ in
            !self.viewModel.isLoading && self.viewModel.error == nil
        }
        await fulfillment(of: [expectation(for: predicate, evaluatedWith: nil)])
        
        XCTAssertEqual(viewModel.user, expectedUser)
    }
    
    func testFailedUserFetch() async {
        // Given
        let expectedError = NSError(domain: "test", code: 404)
        mockNetworkService.fetchUserResult = .failure(expectedError)
        
        // When
        viewModel.fetchUser(username: "nonexistent")
        
        // Then
        let predicate = NSPredicate { _, _ in
            !self.viewModel.isLoading
        }
        await fulfillment(of: [expectation(for: predicate, evaluatedWith: nil)])
        
        XCTAssertNotNil(viewModel.error)
        XCTAssertNil(viewModel.user)
    }
}
