//
//  SeriesModel.swift
//  Starter
//
//  Created by kira on 17/03/2022.
//

import Foundation

protocol SeriesModel {
    func getPopularSeries(completion: @escaping (MDBResult<[MovieResult]>) -> Void)
    func getSeriesDetailsByID(id: Int, completion: @escaping (MDBResult<MovieResult>) -> Void)
    func getSeriesTrailers(id: Int, completion: @escaping (MDBResult<TrailersResponse>) -> Void)
    func getSeriesCredits(of id: Int, completion: @escaping (MDBResult<[ActorResult]>) -> Void)
    func getSimilarSeries(id: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void)
}

class SeriesModelImpl: SeriesModel {
    static let shared = SeriesModelImpl()
    private init() { }
    
    private let networkAgent: NetworkAgentProtocol = AlamofireNetworkAgent.shared
    private let movieRepository: MovieRepository = MovieRepositoryRealm.shared
    private let contentTypeRepository = ContentTypeRepositoryRealm.shared
    
    func getPopularSeries(completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
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
    
    func getSeriesDetailsByID(id: Int, completion: @escaping (MDBResult<MovieResult>) -> Void) {
        networkAgent.getSeriesDetailsByID(id: id) { result in
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
    
    func getSeriesTrailers(id: Int, completion: @escaping (MDBResult<TrailersResponse>) -> Void) {
        networkAgent.getSeriesTrailers(id: id, completion: completion)
    }
    
    func getSeriesCredits(of id: Int, completion: @escaping (MDBResult<[ActorResult]>) -> Void) {
        networkAgent.getSeriesCredits(of: id) { result in
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
    
    func getSimilarSeries(id: Int, completion: @escaping (MDBResult<[MovieResult]>) -> Void) {
        networkAgent.getSimilarSeries(id: id) { result in
            switch result {
            case .success(let data):
                self.movieRepository.saveSimilarMovies(of: id, data: data)
            case .failure(let error):
                print(("\(#function) \(error)"))
            }
            self.movieRepository.getSimilarMovies(of: id) { result in
                completion(.success(result))
            }
        }
    }
    
}
