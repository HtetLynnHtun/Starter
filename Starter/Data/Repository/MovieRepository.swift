//
//  MovieRepository.swift
//  Starter
//
//  Created by kira on 22/03/2022.
//

import Foundation

protocol MovieRepository {
    func saveList(data: [MovieResult], type: MovieSeriesGroupType)
    func saveDetails(data: MovieResult)
    func getDetails(of id: Int, completion: @escaping (MovieResult?) -> Void)
    func saveMovieCredits(of id: Int, data: CreditsResponse)
    func getMovieCredits(of id: Int, completion: @escaping ([ActorResult]) -> Void)
    func saveSimilarMovies(of id: Int, data: MovieListResponse)
    func getSimilarMovies(of id: Int, completion: @escaping ([MovieResult]) -> Void)
}

class MovieRepositoryImpl: BaseRepository, MovieRepository {
    static let shared = MovieRepositoryImpl()
    private override init() {
        super.init()
    }
    
    private let contentTypeRepository = ContentTypeRepositoryImpl.shared
        
    func saveList(data: [MovieResult], type: MovieSeriesGroupType) {
        data.forEach({ result in
            result.toMovieEntity(
                context: self.coreData.context,
                groupType: contentTypeRepository.getBelongsToTypeEntity(type: type)
            )
        })
        self.coreData.saveContext()
    }
    
    func saveDetails(data: MovieResult) {
        data.toMovieEntity(context: self.coreData.context, groupType: nil)
        self.coreData.saveContext()
    }
    
    func getDetails(of id: Int, completion: @escaping (MovieResult?) -> Void) {
        let fetchRequest = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %d", "id", id)
        
        do {
            let results = try self.coreData.context.fetch(fetchRequest)
            if let entity = results.first {
                completion(MovieEntity.toMovieResult(entity: entity))
            } else {
                completion(nil)
            }
        } catch {
            print("\(#function) \(error.localizedDescription)")
        }
    }
    
    func saveMovieCredits(of id: Int, data: CreditsResponse) {
        let fetchRequest = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %d", "id", id)
        
        do {
            let results = try self.coreData.context.fetch(fetchRequest)
            if let entity = results.first {
                data.cast?.forEach({ cast in
                    let actorEntity = cast.toActorResult().toActorEntity(context: self.coreData.context)
                    entity.addToCasts(actorEntity)
                })
                self.coreData.saveContext()
            }
        } catch {
            print("\(#function) \(error.localizedDescription)")
        }
    }
    
    func getMovieCredits(of id: Int, completion: @escaping ([ActorResult]) -> Void) {
        let fetchReqeust = MovieEntity.fetchRequest()
        fetchReqeust.predicate = NSPredicate(format: "%K = %d", "id", id)
        
        do {
            let results = try self.coreData.context.fetch(fetchReqeust)
            if let entity = results.first,
               let credits = entity.casts as? Set<ActorEntity> {
                let data = credits.map { actorEntity in
                    return ActorEntity.toActorResult(entity: actorEntity)
                }.sorted { first, second in
                    first.popularity! > second.popularity!
                }
                completion(data)
            }
        } catch {
            print("\(#function) \(error.localizedDescription)")
        }
    }
    
    func saveSimilarMovies(of id: Int, data: MovieListResponse) {
        let fetchReqeust = MovieEntity.fetchRequest()
        fetchReqeust.predicate = NSPredicate(format: "%K = %d", "id", id)
        
        do {
            let results = try self.coreData.context.fetch(fetchReqeust)
            if let entity = results.first {
                data.results?.forEach({ movieResult in
                    let movieEntity = movieResult.toMovieEntity(context: self.coreData.context, groupType: nil)
                    entity.addToSimilarMovies(movieEntity)
                })
                self.coreData.saveContext()
            }
        } catch {
            print("\(#function) \(error.localizedDescription)")
        }
    }
    
    func getSimilarMovies(of id: Int, completion: @escaping ([MovieResult]) -> Void) {
        let fetchReqeust = MovieEntity.fetchRequest()
        fetchReqeust.predicate = NSPredicate(format: "%K = %d", "id", id)
        
        do {
            let results = try self.coreData.context.fetch(fetchReqeust)
            if let entity = results.first,
               let similarMovies = entity.similarMovies as? Set<MovieEntity> {
                let data = similarMovies.map { movieEntity in
                    return MovieEntity.toMovieResult(entity: movieEntity)
                }
                completion(data)
            }
        } catch {
            print("\(#function) \(error.localizedDescription)")
        }
    }
}
