//
//  NetworkServiceTests.swift
//  GitHubAppTests
//
//  Created by mac on 12/5/25.
//

import XCTest
import Combine
@testable import GitHubApp

class NetworkServiceTests: XCTestCase {
    var networkService: NetworkService!
    var cancellables: Set<AnyCancellable>!
    var mockURLSession: URLSession!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockURLSession = URLSession(configuration: configuration)
        networkService = NetworkService()
        cancellables = []
    }
    
    override func tearDown() {
        networkService = nil
        cancellables = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    // MARK: - Test Helpers
    
    private func mockResponse(for url: URL, statusCode: Int, data: Data) {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: url,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, data)
        }
    }
    
    // MARK: - fetchGitHubUsers Tests
    
    func testFetchGitHubUsers_Success() {
        // Given
        let query = "test"
        let expectedResponse = GitHubSearchResponse.mock
        let data = try! JSONEncoder().encode(expectedResponse)
        let url = URL(string: GitHubAPI.searchQueryEndpoint + query)!
        mockResponse(for: url, statusCode: 200, data: data)
        
        let expectation = XCTestExpectation(description: "Fetch users succeeds")
        
        // When
        networkService.fetchGitHubUsers(query: query)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got failure: \(error)")
                }
            }, receiveValue: { response in
                // Then
                XCTAssertEqual(response.totalCount, 1)
                XCTAssertEqual(response.items.first?.id, GitHubUser.mock.id)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchGitHubUsers_Failure() {
        // Given
        let query = "test"
        let url = URL(string: GitHubAPI.searchQueryEndpoint + query)!
        mockResponse(for: url, statusCode: 404, data: Data())
        
        let expectation = XCTestExpectation(description: "Fetch users fails")
        
        // When
        networkService.fetchGitHubUsers(query: query)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - fetchGitHubUser Tests
    
    func testFetchGitHubUser_Success() {
        // Given
        let username = "testuser"
        let expectedUser = User.mock
        let data = try! JSONEncoder().encode(expectedUser)
        let url = URL(string: GitHubAPI.searchEndpoint + username)!
        mockResponse(for: url, statusCode: 200, data: data)
        
        let expectation = XCTestExpectation(description: "Fetch user succeeds")
        
        // When
        networkService.fetchGitHubUser(username: username)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got failure: \(error)")
                }
            }, receiveValue: { user in
                // Then
                XCTAssertEqual(user.id, expectedUser.id)
                XCTAssertEqual(user.login, expectedUser.login)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchGitHubUser_CacheHit() {
        // Given
        let username = "testuser"
        let expectedUser = User.mock
        let data = try! JSONEncoder().encode(expectedUser)
        networkService.cache.setObject(data as NSData, forKey: NSString(string: "user_\(username)"))
        
        let expectation = XCTestExpectation(description: "Fetch user from cache")
        
        // When
        networkService.fetchGitHubUser(username: username)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got failure: \(error)")
                }
            }, receiveValue: { user in
                // Then
                XCTAssertEqual(user.id, expectedUser.id)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - fetchGitHubFollowers Tests
    
    func testFetchGitHubFollowers_Success() {
        // Given
        let username = "testuser"
        let expectedFollowers = [Follower.mock]
        let data = try! JSONEncoder().encode(expectedFollowers)
        let url = URL(string: GitHubAPI.searchEndpoint + username + "/followers?page=1&per_page=30")!
        mockResponse(for: url, statusCode: 200, data: data)
        
        let expectation = XCTestExpectation(description: "Fetch followers succeeds")
        
        // When
        networkService.fetchGitHubFollowers(username: username, followers: true, page: 1, perPage: 30)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got failure: \(error)")
                }
            }, receiveValue: { followers in
                // Then
                XCTAssertEqual(followers.count, 1)
                XCTAssertEqual(followers.first?.id, Follower.mock.id)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchGitHubFollowing_Success() {
        // Given
        let username = "testuser"
        let expectedFollowing = [Follower.mock]
        let data = try! JSONEncoder().encode(expectedFollowing)
        let url = URL(string: GitHubAPI.searchEndpoint + username + "/following?page=1&per_page=30")!
        mockResponse(for: url, statusCode: 200, data: data)
        
        let expectation = XCTestExpectation(description: "Fetch following succeeds")
        
        // When
        networkService.fetchGitHubFollowers(username: username, followers: false, page: 1, perPage: 30)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got failure: \(error)")
                }
            }, receiveValue: { following in
                // Then
                XCTAssertEqual(following.count, 1)
                XCTAssertEqual(following.first?.id, Follower.mock.id)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchGitHubFollowers_Failure() {
        // Given
        let username = "testuser"
        let url = URL(string: GitHubAPI.searchEndpoint + username + "/followers?page=1&per_page=30")!
        mockResponse(for: url, statusCode: 404, data: Data())
        
        let expectation = XCTestExpectation(description: "Fetch followers fails")
        
        // When
        networkService.fetchGitHubFollowers(username: username, followers: true, page: 1, perPage: 30)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("No request handler provided")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}
