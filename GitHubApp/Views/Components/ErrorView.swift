//
//  ErrorView.swift
//  GitHubApp
//
//  Created by Naoufal on 10/5/25.
//

import SwiftUI

struct ErrorView: View {
    let error: NetworkError
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            Text(error.localizedDescription)
                .font(.headline)
                .foregroundColor(.primaryText)
                .multilineTextAlignment(.center)
                .padding()
            
            if let suggestion = error.recoverySuggestion {
                Text(suggestion)
                .foregroundColor(.secondaryText)
                .padding()
            }
        }
        .padding()
    }
}
