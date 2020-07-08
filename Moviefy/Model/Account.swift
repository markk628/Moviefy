//
//  Account.swift
//  Moviefy
//
//  Created by Mark Kim on 7/8/20.
//  Copyright © 2020 Adriana González Martínez. All rights reserved.
//

import Foundation

struct Account: Codable {
    let id: Int
    let name: String?
    let userName: String?
    
    var displayName: String {
        if let name = name, !name.isEmpty {
            return name
        }
        return userName ?? "(unknown)"
    }
}
