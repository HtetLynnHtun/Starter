//
//  ContentTypeRepository.swift
//  Starter
//
//  Created by kira on 23/03/2022.
//

import Foundation
import CoreData

protocol ContentTypeRepository {
    func save(name: String) -> BelongsToTypeEntity
    func getMoviesOrSeries(type: MovieSeriesGroupType, completion: @escaping ([MovieResult]) -> Void)
    func getBelongsToTypeEntity(type: MovieSeriesGroupType) -> BelongsToTypeEntity
    func getTopRatedMovies(page: Int, completion: @escaping ([MovieResult]) -> Void)
    func getTopRatedMoviesTotalPages(completion: @escaping (Int) -> Void)
}

class ContentTypeRepositoryImpl: BaseRepository, ContentTypeRepository {
    static let shared = ContentTypeRepositoryImpl()
    
    private var contentTypeMap = [String: BelongsToTypeEntity]()
    
    private override init() {
        super.init()
        initializeData()
    }
    
    private func initializeData() {
        let fetchRequest = BelongsToTypeEntity.fetchRequest()
        do {
            let data = try coreData.context.fetch(fetchRequest)
            
            if data.isEmpty {
                MovieSeriesGroupType.allCases.forEach { group in
                    save(name: group.rawValue)
                }
            } else {
                data.forEach { entity in
                    if let key = entity.name {
                        contentTypeMap[key] = entity
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @discardableResult
    func save(name: String) -> BelongsToTypeEntity {
        let entity = BelongsToTypeEntity(context: coreData.context)
        entity.name = name
        contentTypeMap[name] = entity
        coreData.saveContext()
        return entity
    }
    
    func getMoviesOrSeries(type: MovieSeriesGroupType, completion: @escaping ([MovieResult]) -> Void) {
        if let entity = contentTypeMap[type.rawValue],
           let movies = entity.movies,
           let itemSet = movies as? Set<MovieEntity> {
            let sorted = itemSet.sorted { first, second -> Bool in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let firstDate = dateFormatter.date(from: first.releaseDate ?? "") ?? Date()
                let secondDate = dateFormatter.date(from: second.releaseDate ?? "") ?? Date()
                return firstDate.compare(secondDate) == .orderedDescending
            }
            completion(sorted.map({ entity in
                return MovieEntity.toMovieResult(entity: entity)
            }))
        } else {
            completion([MovieResult]())
        }
    }
    
    // MARK: pagination for TopRatedMovies
    private let itemPerPage = 20
    
    func getTopRatedMoviesTotalPages(completion: @escaping (Int) -> Void) {
        let fetchRequest = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "belongsToType.name CONTAINS[cd] %@", "Top Rated Movies")
        
        do {
            let count = try self.coreData.context.count(for: fetchRequest)
            var totalPages = count / itemPerPage
            if count % itemPerPage != 0 {
                totalPages += 1
            }
            completion(totalPages)
        } catch {
            print("\(#function) \(error.localizedDescription)")
            completion(0)
        }
    }
    
    func getTopRatedMovies(page: Int, completion: @escaping ([MovieResult]) -> Void) {
        let fetchRequest = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "belongsToType.name CONTAINS[cd] %@", "Top Rated Movies")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "voteAverage", ascending: false),
            NSSortDescriptor(key: "popularity", ascending: false)
        ]
        fetchRequest.fetchLimit = itemPerPage
        fetchRequest.fetchOffset = (itemPerPage * page) - itemPerPage
        
        do {
            let results = try self.coreData.context.fetch(fetchRequest)
            let items = results.map { entity in
                return MovieEntity.toMovieResult(entity: entity)
            }
            completion(items)
        } catch {
            completion([])
            print("\(#function) \(error.localizedDescription)")
        }
    }
    
    func getBelongsToTypeEntity(type: MovieSeriesGroupType) -> BelongsToTypeEntity {
        if let entity = contentTypeMap[type.rawValue] {
            return entity
        }
        
        return save(name: type.rawValue)
    }
    
}
