//
//  SearchView.swift
//  GitHubApp
//
//  Created by Naoufal on 10/5/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(text: $viewModel.searchQuery, onCommit: viewModel.searchUsers)
                    .padding()
                
                if viewModel.isLoading {
                    ForEach(0..<8) { _ in
                        SkeletonListRow()
                    }
                } else if let error = viewModel.error {
                    ErrorView(error: error)
                } else if viewModel.searchResults.isEmpty && !viewModel.searchQuery.isEmpty {
                    Text("search.empty_prompt".localized())
                        .foregroundColor(.gray)
                } else {
                    List(viewModel.searchResults) { user in
                        NavigationLink(value: user) {
                            UserRow(user: user)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .navigationDestination(for: GitHubUser.self) { user in
                        UserProfileView(username: user.login)
                    }
                }
                
                Spacer()
            }
            .background(Color.appBackground)
            .navigationTitle("search.title".localized())
        }
    }
}
