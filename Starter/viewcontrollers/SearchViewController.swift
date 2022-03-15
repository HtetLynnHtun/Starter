//
//  SearchViewController.swift
//  Starter
//
//  Created by kira on 15/03/2022.
//

import UIKit

class SearchViewController: UIViewController, MovieItemDelegate {
    
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var collectionViewContent: UICollectionView!
    
    let networkAgent = MovieDBNetworkAgent.shared
    var data = [SearchResult] ()
    var currentPage = 1
    var totalPages = 1
    var itemSpacing = 12
    var searchedQuery = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldSearch.delegate = self
        registerCells()
    }
    
    private func registerCells() {
        collectionViewContent.dataSource = self
        collectionViewContent.delegate = self
        collectionViewContent.registerForCell(PopularFilmCollectionViewCell.identifier)
    }

    @IBAction func onTapBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func startSearching(query: String, page: Int) {
        networkAgent.searchMoviesAndSeries(query: query, page: page) { searchResponse in
            let data = searchResponse.results.filter { result in
                result.mediaType == "tv" || result.mediaType == "movie"
            }
            if (self.searchedQuery != query) {
                self.searchedQuery = query
                self.data = data
                self.totalPages = searchResponse.totalPages ?? 1
            } else {
                self.data.append(contentsOf: data)
            }
            self.collectionViewContent.reloadData()
        } failure: { error in
            print(error)
        }

    }
    
    func onTapMovie(id: Int, contentType: DetailContentType) {
        navigateToMovieDetailViewController(id: id, contentType: contentType)
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let query = textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        startSearching(query: query, page: 1)
        return textField.resignFirstResponder()
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeCell(identifier: PopularFilmCollectionViewCell.identifier, indexPath: indexPath) as! PopularFilmCollectionViewCell
        cell.data = data[indexPath.row].toMediaResult()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let isLastItem = indexPath.row == data.count - 1
        let hasMorePage = currentPage < totalPages
        if (isLastItem && hasMorePage) {
            currentPage += 1
            startSearching(query: searchedQuery, page: currentPage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItemData = data[indexPath.row]
        if (selectedItemData.mediaType == "tv") {
            onTapMovie(id: selectedItemData.id ?? -1, contentType: .series)
        } else {
            onTapMovie(id: selectedItemData.id ?? -1, contentType: .movie)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = ((collectionView.frame.width - 48) / 3).rounded(.down)
        let itemHeight = 250.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
