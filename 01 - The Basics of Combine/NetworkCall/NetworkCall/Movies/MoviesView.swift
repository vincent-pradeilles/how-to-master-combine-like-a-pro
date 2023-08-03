//
//  ContentView.swift
//  NetworkCall
//
//  Created by Vincent on 27/07/2023.
//

import SwiftUI

struct MoviesView: View {
    
    @StateObject var viewModel = MovieViewModel()
    
    var body: some View {
        List(viewModel.movies) { movie in
            NavigationLink {
                MovieDetailsView(movie: movie)
            } label: {
                HStack {
                    AsyncImage(url: movie.posterURL) { poster in
                        poster
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 100)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(movie.title)
                            .font(.headline)
                        Text(movie.overview)
                            .font(.caption)
                            .lineLimit(3)
                    }
                }
            }
        }
        .navigationTitle("Upcoming Movies")
        .searchable(text: $viewModel.searchQuery)
        .onAppear {
            viewModel.fetchInitialData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView()
    }
}
