//
//  Movie.swift
//  Moviefy
//
//  Created by Adriana González Martínez on 4/7/20.
//  Copyright © 2020 Adriana González Martínez. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let posterPath: String
    let releaseDate: String
    
    enum MovieCodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
    
    init(from decoder: Decoder) throws {
        let movieContainer = try decoder.container(keyedBy: MovieCodingKeys.self)
        id = try movieContainer.decode(Int.self, forKey: .id)
        title = try movieContainer.decode(String.self, forKey: .title)
        posterPath = try movieContainer.decode(String.self, forKey: .posterPath)
        releaseDate = try movieContainer.decode(String.self, forKey: .releaseDate)
    }
}

struct MovieApiResponse: Codable {
    let page: Int
    let numberOfPages: Int
    let movies: [Movie]
    
    private enum MovieApiResponseCodingKeys: String, CodingKey{
        case page
        case numberOfPages = "total_pages"
        case movies = "results"
    }
    
    init(from decoder: Decoder) throws {
        let movieApiContainer = try decoder.container(keyedBy: MovieApiResponseCodingKeys.self)
        page = try movieApiContainer.decode(Int.self, forKey: .page)
        numberOfPages = try movieApiContainer.decode(Int.self, forKey: .numberOfPages)
        movies = try movieApiContainer.decode([Movie].self, forKey: .movies)
    }
}


