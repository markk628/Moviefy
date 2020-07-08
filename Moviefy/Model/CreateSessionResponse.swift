//
//  CreateSessionResponse.swift
//  Moviefy
//
//  Created by Mark Kim on 7/8/20.
//  Copyright © 2020 Adriana González Martínez. All rights reserved.
//

import Foundation

struct CreateSessionResponse: Codable {
    let success: Bool
    let session_id: String
}
