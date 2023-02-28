//
//  MainScreenViewModel.swift
//  Alfagift-TechnicalTest
//
//  Created by Vincent on 28/02/23.
//

import UIKit

extension ViewController {
    func showNoConnectionAlert() {
        let alert = UIAlertController(title: "Error", message: "No internet Connection", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchMovieList() {
        APIService.shared.AFMovieList(page: currentPage) { movie in
            DispatchQueue.main.async {
                self.movieData = movie
                self.movieCollectionView.reloadData()
            }
        }
    }
    
    func fetchMovieListNextPage() {
        APIService.shared.AFMovieList(page: currentPage) { movie in
            DispatchQueue.main.async {
                self.movieData.results?.append(contentsOf: movie.results ?? [])
                self.movieCollectionView.reloadData()
            }
        }
    }
    
    func fetchMovieSearch(searchedText: String) {
        APIService.shared.AFMovieSearch(page: currentPage, title: searchedText) { movie in
            DispatchQueue.main.async {
                self.movieData = movie
                self.movieCollectionView.reloadData()
            }
        }
    }
    
    func fetchMovieSearchNextPage() {
        APIService.shared.AFMovieSearch(page: currentPage, title: movieSearchBar.text ?? "", completion: { movie in
            DispatchQueue.main.async {
                self.movieData.results?.append(contentsOf: movie.results ?? [])
                self.movieCollectionView.reloadData()
            }
        })
    }
}
