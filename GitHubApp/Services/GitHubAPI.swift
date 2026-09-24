//
//  GitHubAPI.swift
//  GitHubApp
//
//  Created by Naoufal on 11/5/25.
//

import Foundation

struct GitHubAPI {
    public static var BASE_URL: String = "https://api.github.com"
    static var searchQueryEndpoint : String = BASE_URL + "/search/users?q="
    static var searchEndpoint : String = BASE_URL + "/users/"
}
