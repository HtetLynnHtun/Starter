//
//  SearchViewController.swift
//  Starter
//
//  Created by kira on 15/03/2022.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController, MovieItemDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionViewContent: UICollectionView!
    
    // MARK: - properties
    private let searchModel: SearchModel = SearchModelImpl.shared
    var searchBar = UISearchBar()
    let networkAgent = AlamofireNetworkAgent.shared
    var data = [SearchResult] ()
    var currentPage = 1
    var totalPages = 1
    var itemSpacing = 12
    var searchedQuery = ""
    private let disposeBag = DisposeBag()
    private let searchResultsSubject = BehaviorSubject(value: [SearchResult]())
    
    // MARK: - view lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        registerCells()
        initObservers()
    }
    
    private func initObservers() {
        addSearchBarObserver()
        addCollectionViewBindingObserver()
        addPaginationObserver()
        addItemSelectedObserver()
    }
    
    // MARK: - view setups
    private func setupSearchBar() {
        searchBar.placeholder = "Search..."
        searchBar.tintColor = .white
        let textOfSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textOfSearchBar?.textColor = .white
        navigationItem.titleView = searchBar
    }
    
    // MARK: - cell registrations
    private func registerCells() {
        collectionViewContent.delegate = self
        collectionViewContent.registerForCell(PopularFilmCollectionViewCell.identifier)
    }
    
    // MARK: - onTap callbacks
    func onTapMovie(id: Int, contentType: DetailContentType) {
        navigateToMovieDetailViewController(id: id, contentType: contentType)
    }
    
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = ((collectionView.frame.width - 48) / 3).rounded(.down)
        let itemHeight = 250.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

// MARK: - Rx extensions
extension SearchViewController {
    private func rxMovieSearch(query: String, page: Int) {
        RxNetworkAgent.shared.searchMoviesAndSeries(query: query, page: page)
            .do(onNext: { value in
                self.totalPages = value.totalPages ?? 1
            })
            .compactMap { $0.results }
            .subscribe(onNext: { value in
                if (self.currentPage == 1) {
                    self.searchResultsSubject.onNext(value)
                } else {
                    self.searchResultsSubject.onNext(try! self.searchResultsSubject.value() + value)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func addSearchBarObserver() {
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .do(onNext: { print($0)})
            .subscribe(onNext: { value in
                if value.isEmpty {
                    self.currentPage = 1
                    self.totalPages = 1
                    self.searchResultsSubject.onNext([])
                } else {
                    self.rxMovieSearch(query: value, page: self.currentPage)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func addCollectionViewBindingObserver() {
        searchResultsSubject
            .bind(to: collectionViewContent.rx.items(
                cellIdentifier: PopularFilmCollectionViewCell.identifier,
                cellType: PopularFilmCollectionViewCell.self))
        { row, element, cell in
            cell.data = element.toMediaResult()
        }
        .disposed(by: disposeBag)
    }
    
    private func addPaginationObserver() {
        Observable.combineLatest(
            collectionViewContent.rx.willDisplayCell,
            searchBar.rx.text.orEmpty)
        .subscribe(onNext: { (cellTuple, searchText) in
            let (_, indexPath) = cellTuple
            let totalItems = try! self.searchResultsSubject.value().count
            let isAtLastRow = indexPath.row == totalItems - 1
            let hasMorePage = self.currentPage < self.totalPages
            if (isAtLastRow && hasMorePage) {
                self.currentPage += 1
                self.rxMovieSearch(query: searchText, page: self.currentPage)
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func addItemSelectedObserver() {
        collectionViewContent.rx.itemSelected
            .subscribe(onNext: { indexPath in
                let selectedItem = try! self.searchResultsSubject.value()[indexPath.row]
                let contentType: DetailContentType!
                if (selectedItem.mediaType == "tv") {
                    contentType = .series
                } else {
                    contentType = .movie
                }
                self.navigateToMovieDetailViewController(id: selectedItem.id!, contentType: contentType)
            })
            .disposed(by: disposeBag)
    }
}
