//
//  SearchBar.swift
//  GitHubApp
//
//  Created by Naoufal on 10/5/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onCommit: () -> Void
    var body: some View {
        HStack {
            TextField("search.placeholder".localized(), text: $text, onCommit: onCommit)
                .padding(8)
                .padding(.horizontal, 24)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !text.isEmpty {
                            Button(action: {
                                text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                ).padding(.horizontal, 10)
        }
    }
}
