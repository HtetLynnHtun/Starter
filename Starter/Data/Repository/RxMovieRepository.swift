//
//  RxMovieRepository.swift
//  Starter
//
//  Created by kira on 08/05/2022.
//

import Foundation
import RxSwift
import CoreData

class RxMovieRepository: BaseRepository {
    
    static let shared = RxMovieRepository()
    
    private override init() {
        super.init()
    }
    
    func saveDetails(data: MovieResult) {
        data.toMovieEntity(context: self.coreData.context, groupType: nil)
        self.coreData.saveContext()
    }
    
    private let movieDetailsSubject = PublishSubject<(MovieResult, [ActorResult])>()
    private var movieDetailsFRC: NSFetchedResultsController<MovieEntity>!
    
    func getMovieDetails(of id: Int) -> Observable<(MovieResult, [ActorResult])> {
        let fetchReqeust = MovieEntity.fetchRequest()
        fetchReqeust.predicate = NSPredicate(format: "%K = %d", "id", id)
        fetchReqeust.sortDescriptors = [NSSortDescriptor(key: "voteAverage", ascending: false)]
        
        movieDetailsFRC = NSFetchedResultsController(fetchRequest: fetchReqeust, managedObjectContext: coreData.context, sectionNameKeyPath: nil, cacheName: nil)
        movieDetailsFRC.delegate = self
        
        do {
            try movieDetailsFRC.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        return movieDetailsSubject
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
    
    private let movieCreditsSubject = PublishSubject<[ActorResult]>()
    private var movieCreditsFRC: NSFetchedResultsController<ActorEntity>!
    func getMovieCredits(of id: Int) -> Observable<[ActorResult]> {
        let fetchRequest = ActorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: <#T##String#>, <#T##args: CVarArg...##CVarArg#>)
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
    
    private let similarMoviesSubject = BehaviorSubject<[MovieResult]>(value: [])
    private var fetchResultsController: NSFetchedResultsController<MovieEntity>!
    
    func getSimilarMovies(of id: Int) -> Observable<[MovieResult]>{
        let fetchReqeust = MovieEntity.fetchRequest()
        fetchReqeust.predicate = NSPredicate(format: "%K = %d", "id", id)
        fetchReqeust.sortDescriptors = [NSSortDescriptor(key: "voteAverage", ascending: false)]
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchReqeust, managedObjectContext: coreData.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        do {
            try fetchResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        return similarMoviesSubject
    }
    
    
}

extension RxMovieRepository: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if (controller == fetchResultsController) {
            didChangeData()
        } else if (controller == movieDetailsFRC) {
            didChangeMovieDetails()
        }
    }
}

// MARK: - Notifier methods
extension RxMovieRepository {
    private func didChangeData() {
        if let movieEntity = fetchResultsController.fetchedObjects?.first,
           let similarMovies = movieEntity.similarMovies as? Set<MovieEntity>,
           !similarMovies.isEmpty {
            
            let data = similarMovies.map { MovieEntity.toMovieResult(entity: $0)}
                .sorted { $0.voteAverage ?? 0 > $1.voteAverage ?? 0 }
            similarMoviesSubject.onNext(data)
        }
    }
    
    private func didChangeMovieDetails() {
        if let movieEntity = movieDetailsFRC.fetchedObjects?.first {
            let movieResult = MovieEntity.toMovieResult(entity: movieEntity)
            let credits = (movieEntity.casts as! Set<ActorEntity>).map { actorEntity in
                 return ActorEntity.toActorResult(entity: actorEntity)
             }.sorted { first, second in
                 first.popularity! > second.popularity!
             }
            
            movieDetailsSubject.onNext((movieResult, credits))
        }
    }
}
