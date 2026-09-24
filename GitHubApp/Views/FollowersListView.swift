//
//  FollowersListView.swift
//  GitHubApp
//
//  Created by Naoufal on 10/5/25.
//

import SwiftUI
import Kingfisher

struct FollowersListView: View {
    let username: String
    let totalCount: Int
    let isFollowing: Bool
    @StateObject private var viewModel = FollowersViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.followers.isEmpty {
                    ForEach(0..<8) { _ in
                        SkeletonListRow()
                    }
                } else if let error = viewModel.error {
                    ErrorView(error: error)
                } else {
                    List {
                        ForEach(viewModel.followers) { follower in
                            NavigationLink(destination: UserProfileView(username: follower.login)) {
                                HStack {
                                    KFImage( URL(string: follower.avatarUrl))
                                        .resizable()
                                        .placeholder {
                                            ProgressView()
                                        }
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                    
                                    Text(follower.login)
                                        .foregroundColor(.primaryText)
                                }
                            }
                        }
                        
                        if viewModel.isLoadingMore {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .listRowSeparator(.hidden)
                        }
                        
                        Color.clear
                            .frame(height: 1)
                            .onAppear {
                                if !viewModel.isLoadingMore {
                                    loadMoreData()
                                }
                            }
                    }
                    .refreshable {
                        refreshData()
                    }
                }
            }
            .background(Color.appBackground)
            .navigationTitle(isFollowing ? "profile.following".localized() : "profile.followers".localized())
            .onAppear {
                if viewModel.followers.isEmpty {
                    loadData()
                }
            }
        }
    }
    
    private func loadData() {
        if isFollowing {
            // Note: GitHub API has a separate endpoint for following
            viewModel.fetchFollowers(username: username, followers: false, isInitialLoad: true, totalCount: totalCount)
        } else {
            viewModel.fetchFollowers(username: username, followers: true, isInitialLoad: true, totalCount: totalCount)
        }
    }
    
    private func loadMoreData() {
        if isFollowing {
            // Note: GitHub API has a separate endpoint for following
            viewModel.fetchFollowers(username: username, followers: false, isInitialLoad: false, totalCount: totalCount)
        } else {
            viewModel.fetchFollowers(username: username, followers: true, isInitialLoad: false, totalCount: totalCount)
        }
    }
    
    private func refreshData() {
        if isFollowing {
            // Note: GitHub API has a separate endpoint for following
            viewModel.fetchFollowers(username: username, followers: false, totalCount: totalCount)
        } else {
            viewModel.fetchFollowers(username: username, followers: true, totalCount: totalCount)
        }
    }
}
