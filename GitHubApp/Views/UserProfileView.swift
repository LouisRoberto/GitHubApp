//
//  UserProfileView.swift
//  GitHubApp
//
//  Created by Naoufal on 10/5/25.
//

import SwiftUI
import Kingfisher

struct UserProfileView: View {
    let username: String
    @StateObject private var viewModel = UserViewModel()
    @State private var showFollowers = false
    @State private var showFollowing = false
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                SkeletonView()
                    .frame(minHeight: 400)
            } else if let error = viewModel.error {
                ErrorView(error: error)
            } else if let user = viewModel.user {
                profileContent(for: user)
            }
        }
        .navigationTitle(username)
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity)
        .refreshable {
            Task {
                await viewModel.retrieveUser(username: username)
            }
        }
        .onAppear {
            if viewModel.user == nil {
                Task {
                    await viewModel.retrieveUser(username: username)
                }
            }
        }
        .sheet(isPresented: $showFollowers) {
            NavigationStack {
                FollowersListView(username: username, totalCount: viewModel.user?.followers ?? 0, isFollowing: false)
            }
        }
        .sheet(isPresented: $showFollowing) {
            NavigationStack {
                FollowersListView(username: username, totalCount: viewModel.user?.following ?? 0, isFollowing: true)
            }
        }
        .background(Color.appBackground)
    }
    
    @ViewBuilder
    private func profileContent(for user: User) -> some View {
        VStack(spacing: 20) {
            KFImage( URL(string: user.avatarUrl))
                .resizable()
                .placeholder {
                    ProgressView()
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
            
            VStack(spacing: 8) {
                Text(user.login)
                    .font(.title)
                    .foregroundColor(.primaryText)
                
                if let name = user.name {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(.primaryText)
                }
                
                if let bio = user.bio {
                    Text(bio)
                        .font(.body)
                        .foregroundColor(.primaryText)
                        .multilineTextAlignment(.center)
                } else {
                    Text("profile.no_bio".localized())
                        .foregroundColor(.secondaryText)
                }
            }
            .padding(.horizontal)
            
            HStack(spacing: 30) {
                Button(action: { showFollowers = true }) {
                    VStack {
                        Text("\(user.followers)")
                            .font(.title2)
                        Text("profile.followers".localized())
                            .font(.caption)
                    }
                }
                
                Button(action: { showFollowing = true }) {
                    VStack {
                        Text("\(user.following)")
                            .font(.title2)
                        Text("profile.following".localized())
                            .font(.caption)
                    }
                }
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .background(Color.appBackground)
    }
}
