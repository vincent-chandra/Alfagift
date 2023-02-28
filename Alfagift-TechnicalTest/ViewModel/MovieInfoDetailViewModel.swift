//
//  MovieInfoDetailViewModel.swift
//  Alfagift-TechnicalTest
//
//  Created by Vincent on 28/02/23.
//

import UIKit

extension MovieInfoDetailVC {
    func showNoConnectionAlert() {
        let alert = UIAlertController(title: "Error", message: "No internet Connection", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchMovieDetail() {
        APIService.shared.AFMovieDetail(id: id) { [weak self] data in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.arrMovieDetails = data
                self.bannerImageView.loadImage(fromURL: "https://image.tmdb.org/t/p/original\(data.backdrop_path ?? "")")
                self.posterImageView.loadImage(fromURL: "https://image.tmdb.org/t/p/original\(data.poster_path ?? "")")
                self.movieTitleLabel.text = data.title
                self.averageVoteLabel.text = "\(data.vote_average ?? 0.0)/10"
                self.popularityLabel.text = "Popularity: \(Int(data.popularity ?? 0))"
                self.overviewTextView.text = data.overview
                self.title = data.title
            }
        }
    }
    
    func fetchMovieTrailer() {
        APIService.shared.AFMovieTrailer(id: id) { [weak self] data in
            guard let self = self else { return }
            if !(data.results?.isEmpty ?? true) {
                DispatchQueue.main.async {
                    self.loadYoutube(videoID: data.results?[0].key ?? "-aAHfOQ7Rbo")
                }
            }
        }
    }
    
    func fetchUserReview() {
        APIService.shared.AFUserReview(page: currentPageReview, id: id) { [weak self] data in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.arrReview = data
                if data.results?.isEmpty ?? false {
                    self.emptyView.isHidden = false
                    self.userReviewTableHeightConstraint.constant = CGFloat(170)
                    self.userReviewTableView.isHidden = true
                } else {
                    self.userReviewTableHeightConstraint.constant = CGFloat(170*(data.results?.count ?? 0))
                    self.emptyView.isHidden = true
                    self.userReviewTableView.isHidden = false
                }
                self.userReviewTableView.reloadData()
            }
        }
    }
    
    func fetchUserReviewNextPage() {
        APIService.shared.AFUserReview(page: currentPageReview, id: id) { [weak self] data in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.arrReview.results?.append(contentsOf: data.results ?? [])
                self.userReviewTableView.reloadData()
            }
        }
    }
    
    func loadYoutube(videoID:String) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)")
        else { return }
        webKitPlayer.load( URLRequest(url: youtubeURL) )
    }
}
