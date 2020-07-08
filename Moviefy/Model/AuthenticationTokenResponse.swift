//
//  AuthenticationTokenResponse.swift
//  Moviefy
//
//  Created by Mark Kim on 7/8/20.
//  Copyright © 2020 Adriana González Martínez. All rights reserved.
//

import Foundation

struct AuthenticationTokenResponse: Codable {
    let success: Bool
    let expires_at: String
    let request_token: String
}
