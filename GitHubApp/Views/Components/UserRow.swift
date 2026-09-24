//
//  UserRow.swift
//  GitHubApp
//
//  Created by Naoufal on 10/5/25.
//

import SwiftUI
import Kingfisher

struct UserRow: View {
    let user: GitHubUser
    
    var body: some View {
        HStack {
            KFImage( URL(string: user.avatarUrl))
             .resizable()
             .placeholder {
                ProgressView()
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(user.login)
                    .font(.headline)
                    .foregroundColor(.primaryText)
                Text(user.type)
                    .font(.subheadline)
                    .foregroundColor(.secondaryText)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
