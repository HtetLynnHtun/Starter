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
    private var viewModel: SearchViewModel!
    private let disposeBag = DisposeBag()
    
    private var searchBar = UISearchBar()
    
    // MARK: - view lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        registerCells()
        viewModel = SearchViewModelImpl.shared
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
    
    private func addSearchBarObserver() {
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .do(onNext: { print($0)})
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                
                self.viewModel.startSearching(keyword: value)
            })
            .disposed(by: disposeBag)
    }
    
    private func addCollectionViewBindingObserver() {
        viewModel.searchResultsSubject
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
        .subscribe(onNext: { [weak self] (cellTuple, searchText) in
            guard let self = self else { return }
            
            let (_, indexPath) = cellTuple
            self.viewModel.handlePagination(row: indexPath.row, keyword: searchText)
        })
        .disposed(by: disposeBag)
    }
    
    private func addItemSelectedObserver() {
        collectionViewContent.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                
                let selectedItem = try! self.viewModel.searchResultsSubject.value()[indexPath.row]
                let contentType = DetailContentType.of(mediaType: selectedItem.mediaType!)
                self.navigateToMovieDetailViewController(id: selectedItem.id!, contentType: contentType)
            })
            .disposed(by: disposeBag)
    }
}
