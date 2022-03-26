//
//  MovieModel.swift
//  Starter
//
//  Created by kira on 17/03/2022.
//

import Foundation

protocol MovieModel {
    func getUpcomingMovieList(completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getPopularMovieList(completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getPopularSeriesList(completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getMovieGenreList(completion: @escaping (MDBResult<[MovieGenre]>) -> Void)
    func getTopRatedMovieList(page: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getMovieDetailsByID(id: Int, completion: @escaping (MDBResult<MovieResult>) -> Void)
    func getMovieCredits(of id: Int, completion: @escaping (MDBResult<[ActorResult]>) -> Void)
    func getSimilarMovies(id: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getMovieTrailers(id: Int, completion: @escaping (MDBResult<TrailersResponse>) -> Void)
    func getTopRatedMoviesTotalPages() -> Int
}

class MovieModelImpl: MovieModel {
    static let shared = MovieModelImpl()
    private init() { }
    
    let networkAgent: NetworkAgentProtocol = AlamofireNetworkAgent.shared
    let movieRepository: MovieRepository = MovieRepositoryImpl.shared
    let genreRepository: GenreRepository = GenreRepositoryImpl.shared
    let contentTypeRepository: ContentTypeRepository = ContentTypeRepositoryImpl.shared
    
    func getUpcomingMovieList(completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        let contentType: MovieSeriesGroupType = .upcomingMovies
        
        networkAgent.getUpcomingMovieList { result in
            switch result {
            case .success(let data):
                self.movieRepository.saveList(data: data.results ?? [], type: contentType)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.contentTypeRepository.getMoviesOrSeries(type: contentType) { data in
                completion(.success(data))
            }
        }
    }
    
    func getPopularMovieList(completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        let contentType: MovieSeriesGroupType = .popularMovies
        
        networkAgent.getPopularMovieList { result in
            switch result {
            case .success(let data):
                self.movieRepository.saveList(data: data.results ?? [], type: contentType)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.contentTypeRepository.getMoviesOrSeries(type: contentType) { data in
                completion(.success(data))
            }
        }
    }
    
    func getPopularSeriesList(completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        let contentType: MovieSeriesGroupType = .popularSeries
        
        networkAgent.getPopularSeries { result in
            switch result {
            case .success(let data):
                self.movieRepository.saveList(data: data.results ?? [], type: contentType)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            self.contentTypeRepository.getMoviesOrSeries(type: contentType) { data in
                completion(.success(data))
            }
        }
    }
    
    func getMovieGenreList(completion: @escaping (MDBResult<[MovieGenre]>) -> Void) {
        networkAgent.getMovieGenreList { result in
            switch result {
            case .success(let data):
                self.genreRepository.save(data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            self.genreRepository.get { movieGenres in
                completion(.success(movieGenres))
            }
        }
    }
    
    private var totalPages = 0
    func getTopRatedMoviesTotalPages() -> Int {
        return totalPages
    }
    
    func getTopRatedMovieList(page: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        let contentType: MovieSeriesGroupType = .topRatedMovies
        var networkResult = [MovieResult]()
        
        networkAgent.getTopRatedMovieList(page: page) { result in
            switch result {
            case .success(let data):
                networkResult = data.results ?? []
                self.totalPages = data.totalPages ?? 1
                self.movieRepository.saveList(data: networkResult, type: contentType)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            
            if networkResult.isEmpty {
                self.contentTypeRepository.getTopRatedMoviesTotalPages { pages in
                    self.totalPages = pages
                }
            }
            
            self.contentTypeRepository.getTopRatedMovies(page: page) { data in
                completion(.success(data))
            }
        }
    }
    
    func getMovieDetailsByID(id: Int, completion: @escaping (MDBResult<MovieResult>) -> Void) {
        networkAgent.getMovieDetailsByID(id: id) { result in
            switch result {
            case .success(let data):
                self.movieRepository.saveDetails(data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            self.movieRepository.getDetails(of: id) { result in
                if let result = result {
                    completion(.success(result))
                } else {
                    completion(.failure("Fail to fetch details of : \(id)"))
                }
            }
        }
    }
    
    func getMovieCredits(of id: Int, completion: @escaping (MDBResult<[ActorResult]>) -> Void) {
        networkAgent.getMovieCredits(of: id) { result in
            switch result {
            case .success(let data):
                self.movieRepository.saveMovieCredits(of: id, data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            self.movieRepository.getMovieCredits(of: id) { result in
                completion(.success(result))
            }
        }
    }
    
    func getSimilarMovies(id: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        networkAgent.getSimilarMovies(id: id) { result in
            switch result {
            case .success(let data):
                self.movieRepository.saveSimilarMovies(of: id, data: data)
            case .failure(let error):
                print("\(#function) \(error)")
            }
            self.movieRepository.getSimilarMovies(of: id) { result in
                completion(.success(result))
            }
        }
    }
    
    func getMovieTrailers(id: Int, completion: @escaping (MDBResult<TrailersResponse>) -> Void) {
        networkAgent.getMovieTrailers(id: id, completion: completion)
    }
}
