//
//  SearchViewModel.swift
//  Starter
//
//  Created by kira on 21/05/2022.
//

import Foundation
import RxSwift

protocol SearchViewModel {
    var searchResultsSubject: BehaviorSubject<[SearchResult]> { get }
    
    func startSearching(keyword: String)
    func handlePagination(row: Int, keyword: String)
}

class SearchViewModelImpl: SearchViewModel {
    
    static let shared = SearchViewModelImpl()
    private init() { }
    
    let searchResultsSubject = BehaviorSubject(value: [SearchResult]())
    
    private let movieModel: RxMovieModel = RxMovieModelImpl.shared
    private var currentPage = 1
    private var totalPages = 1
    private let disposeBag = DisposeBag()
    
    func startSearching(keyword: String) {
        if keyword.isEmpty {
            currentPage = 1
            totalPages = 1
            searchResultsSubject.onNext([])
        } else {
            searchMovie(keyword: keyword, page: currentPage)
        }
    }
    
    func searchMovie(keyword: String, page: Int) {
        movieModel.searchMoviesAndSeries(query: keyword, page: page)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                
                let results = data.results
                self.totalPages = data.totalPages ?? 1
                
                if (self.currentPage == 1) {
                    self.searchResultsSubject.onNext(results)
                } else {
                    let previousResults = try! self.searchResultsSubject.value()
                    self.searchResultsSubject.onNext(previousResults + results)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func handlePagination(row: Int, keyword: String) {
        let totalItems = try! self.searchResultsSubject.value().count
        let isAtLastRow = row == totalItems - 1
        let hasMorePage = self.currentPage < self.totalPages
        if (isAtLastRow && hasMorePage) {
            self.currentPage += 1
            self.searchMovie(keyword: keyword, page: self.currentPage)
        }
    }
}
