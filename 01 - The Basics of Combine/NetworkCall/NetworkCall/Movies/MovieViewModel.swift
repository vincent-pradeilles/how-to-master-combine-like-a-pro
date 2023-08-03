//
//  MovieViewModel.swift
//  NetworkCall
//
//  Created by Vincent on 27/07/2023.
//

import Combine
import Foundation

final class MovieViewModel: ObservableObject {
    @Published private var upcomingMovies: [Movie] = []

    @Published var searchQuery: String = ""
    @Published private var searchResults: [Movie] = []
    
    var movies: [Movie] {
        if searchQuery.isEmpty {
            return upcomingMovies
        } else {
            return searchResults
        }
    }
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchQuery
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .map { searchQuery in
                searchMovies(for: searchQuery)
                    .replaceError(with: MovieResponse(results: []))
            }
            .switchToLatest()
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .assign(to: &$searchResults)
    }
    
    func fetchInitialData() {
        fetchMovies()
            .map(\.results)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
//            .assign(to: \.movies, on: self)
//            .store(in: &cancellables)
            .assign(to: &$upcomingMovies)
            
//            .sink { completion in
//                switch completion {
//                case .finished:()
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            } receiveValue: { [weak self] movies in
//                self?.movies = movies
//            }
//            .store(in: &cancellables)
    }
}
