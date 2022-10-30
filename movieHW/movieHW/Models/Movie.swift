// Movie.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

// Модель Movie
struct Movie: Decodable {
    let results: [Results]
}

// Модель получаемого запроса для Movie
struct Results: Decodable {
    let id: Int
    let originalLanguage: String
    let title: String
    let overview: String
    let posterPath: String
    let voteAverage: Float
}
