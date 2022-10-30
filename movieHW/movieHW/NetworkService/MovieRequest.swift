// MovieRequest.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Запрос Movie
final class MovieRequest {
    // MARK: - Public Methods

    func getMovies(urlString: String, complition: @escaping (Result<[Results], Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movie = try decoder.decode(Movie.self, from: data)
                let details = movie.results
                complition(.success(details))
            } catch {
                return
            }
        }
        dataTask.resume()
    }
}
