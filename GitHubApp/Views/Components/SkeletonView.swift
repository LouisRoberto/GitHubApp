//
//  SkeletonView.swift
//  GitHubApp
//
//  Created by Naoufal on 10/5/25.
//

import SwiftUI

struct SkeletonView: View {
    @State private var isAnimating = false
    
    // Animation configuration
    private let gradient = Gradient(colors: [
        Color(.systemGray5),
        Color(.systemGray6),
        Color(.systemGray5)
    ])
    
    private let animation = Animation
        .linear(duration: 1.5)
        .repeatForever(autoreverses: false)
    
    var body: some View {
        ZStack {
            // Background layer (static)
            Color(.clear)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Animated layer
            LinearGradient(
                gradient: gradient,
                startPoint: isAnimating ? .leading : .trailing,
                endPoint: isAnimating ? .trailing : .leading
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .mask(skeletonContent())
            .onAppear {
                withAnimation(animation) {
                    isAnimating = true
                }
            }
        }
    }
    
    private func skeletonContent() -> some View {
        VStack(spacing: 16) {
            // Avatar placeholder
            Circle()
                .frame(width: 100, height: 100)
            
            // Text placeholders
            VStack(spacing: 8) {
                Rectangle()
                    .frame(height: 20)
                    .cornerRadius(4)
                
                Rectangle()
                    .frame(height: 16)
                    .cornerRadius(4)
                    .frame(width: 150)
                
                Rectangle()
                    .frame(height: 14)
                    .cornerRadius(4)
                    .frame(width: 200)
            }
            .padding(.horizontal)
            
            // Stats placeholders
            HStack(spacing: 24) {
                VStack {
                    Rectangle()
                        .frame(width: 40, height: 20)
                    Rectangle()
                        .frame(width: 60, height: 12)
                }
                
                VStack {
                    Rectangle()
                        .frame(width: 40, height: 20)
                    Rectangle()
                        .frame(width: 60, height: 12)
                }
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .padding()
    }
}

// Skeleton List Row View
struct SkeletonListRow: View {
    @State private var isAnimating = false
    
    private let gradient = Gradient(colors: [
        Color(.systemGray5),
        Color(.systemGray6),
        Color(.systemGray5)
    ])
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar placeholder
            Circle()
                .frame(width: 50, height: 50)
                .overlay(
                    LinearGradient(
                        gradient: gradient,
                        startPoint: isAnimating ? .leading : .trailing,
                        endPoint: isAnimating ? .trailing : .leading
                    )
                    .mask(Circle())
                    .onAppear {
                        withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                            isAnimating = true
                        }
                    }
                )
            
            // Text placeholders
            VStack(alignment: .leading, spacing: 6) {
                Rectangle()
                    .frame(width: 240, height: 16)
                    .cornerRadius(4)
                    .overlay(
                        LinearGradient(
                            gradient: gradient,
                            startPoint: isAnimating ? .leading : .trailing,
                            endPoint: isAnimating ? .trailing : .leading
                        )
                        .mask(Rectangle())
                        .onAppear {
                            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                                isAnimating = true
                            }
                        }
                    )
                
                Rectangle()
                    .frame(width: 200, height: 12)
                    .cornerRadius(4)
                    .overlay(
                        LinearGradient(
                            gradient: gradient,
                            startPoint: isAnimating ? .leading : .trailing,
                            endPoint: isAnimating ? .trailing : .leading
                        )
                        .mask(Rectangle())
                        .onAppear {
                            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                                isAnimating = true
                            }
                        }
                    )
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
}
