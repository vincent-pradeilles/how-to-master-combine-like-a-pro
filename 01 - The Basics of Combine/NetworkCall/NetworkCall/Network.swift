//
//  Network.swift
//  NetworkCall
//
//  Created by Vincent on 27/07/2023.
//

import Combine
import Foundation

func fetchMovies() -> some Publisher<MovieResponse, Error> {
    let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)")!
    
    return URLSession
        .shared
        .dataTaskPublisher(for: url)
        .map(\.data)
//        .tryMap { data in
//            let decoded = try jsonDecoder.decode(MovieResponse.self, from: data)
//            return decoded
//        }
        .decode(type: MovieResponse.self, decoder: jsonDecoder)
}

func searchMovies(for query: String) -> some Publisher<MovieResponse, Error> {
    let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(encodedQuery!)")!

    return URLSession
        .shared
        .dataTaskPublisher(for: url)
        .map { $0.data }
        .decode(type: MovieResponse.self, decoder: jsonDecoder)
}

enum NetworkingError: Error {
    case invalidURL
}

func fetchCredits(for movie: Movie) -> some Publisher<MovieCreditsResponse, Error> {
    guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id)/credits?api_key=\(apiKey)")
    else { return Fail(error: NetworkingError.invalidURL).eraseToAnyPublisher() }
    
    return URLSession
        .shared
        .dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: MovieCreditsResponse.self, decoder: jsonDecoder)
        .eraseToAnyPublisher()
}

func fetchReviews(for movie: Movie) -> some Publisher<MovieReviewsResponse, Error> {
    guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id)/reviews?api_key=\(apiKey)")
    else { return Fail(error: NetworkingError.invalidURL).eraseToAnyPublisher() }
    
    return URLSession
        .shared
        .dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: MovieReviewsResponse.self, decoder: jsonDecoder)
        .eraseToAnyPublisher()
}

















