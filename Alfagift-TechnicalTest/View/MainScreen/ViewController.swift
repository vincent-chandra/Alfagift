//
//  ViewController.swift
//  Alfagift-TechnicalTest
//
//  Created by Vincent on 28/02/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var movieCollectionView: UICollectionView!

    var movieData = Movies()
    var currentPage = 1
    
    let inset: CGFloat = 10
    let minimumLineSpacing: CGFloat = 10
    let minimumInteritemSpacing: CGFloat = 10
    let cellsPerRow = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        // Check Connection
        if !Connection.checkConnection() {
            showNoConnectionAlert()
        }
        
        // Movie Collection View
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.register(UINib(nibName: "MovieListCollectionCell", bundle: nil), forCellWithReuseIdentifier: "MovieListCollectionCell")
        movieCollectionView.contentInsetAdjustmentBehavior = .always
        
        // Movie Search Bar
        movieSearchBar.delegate = self
        let placeholderAttribute = NSAttributedString(string: "Search Movie", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        movieSearchBar.searchTextField.textColor = .white
        movieSearchBar.searchTextField.attributedPlaceholder = placeholderAttribute
        movieSearchBar.searchTextField.leftView?.tintColor = .lightGray
        
        // Navigation Bar
        self.title = "Discover Movies"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        fetchMovieList()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCollectionCell", for: indexPath) as! MovieListCollectionCell
        cell.movieTitleLabel.text = movieData.results?[indexPath.row].title
        cell.tag = indexPath.row
        
        DispatchQueue.main.async {
            if cell.tag == indexPath.row{
                cell.movieImageView.loadImage(fromURL: "https://image.tmdb.org/t/p/w185\(self.movieData.results?[indexPath.row].poster_path ?? "")")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        return CGSize(width: itemWidth, height: 190)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        movieCollectionView.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == movieData.results!.count - 5){
            if !Connection.checkConnection() {
                showNoConnectionAlert()
            }
            currentPage += 1
            if movieSearchBar.searchTextField.text!.isEmpty{
                fetchMovieListNextPage()
            }else{
                fetchMovieSearchNextPage()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MovieInfoDetailVC()
        vc.id = movieData.results?[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty{
            currentPage = 1
            let searchedText = searchText.replacingOccurrences(of: " ", with: "+")
            if !Connection.checkConnection() {
                showNoConnectionAlert()
            }
            
            fetchMovieSearch(searchedText: searchedText)
        }else{
            fetchMovieList()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = ""
    }
}

