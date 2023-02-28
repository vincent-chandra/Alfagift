//
//  MovieInfoDetailVC.swift
//  Alfagift-TechnicalTest
//
//  Created by Vincent on 28/02/23.
//

import UIKit
import WebKit

class MovieInfoDetailVC: UIViewController {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var averageVoteLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var webKitPlayer: WKWebView!
    @IBOutlet weak var userReviewTableView: UITableView!
    @IBOutlet weak var userReviewLabel: UILabel!
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var userReviewTableHeightConstraint: NSLayoutConstraint!
    
    var arrMovieDetails: MovieDetails?
    var arrReview = Reviews()
    var currentPageReview = 1
    
    var id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        // Check Connection
        if !Connection.checkConnection() {
            showNoConnectionAlert()
        }
        
        // Setup Table
        userReviewTableView.delegate = self
        userReviewTableView.dataSource = self
        
        overviewTextView.isUserInteractionEnabled = false
        
        userReviewTableView.register(UINib(nibName: "UserReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "UserReviewTableViewCell")

        // Fetch Data
        fetchMovieDetail()
        fetchMovieTrailer()
        fetchUserReview()
    }
}

extension MovieInfoDetailVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrReview.results?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userReviewTableView.dequeueReusableCell(withIdentifier: "UserReviewTableViewCell", for: indexPath) as! UserReviewTableViewCell
        cell.contentReviewText.text = arrReview.results?[indexPath.row].content
        cell.rateLabel.text = "10"
        cell.usernameLabel.text = arrReview.results?[indexPath.row].author_details.username

        var avatarImageURL = arrReview.results?[indexPath.row].author_details.avatar_path ?? ""
        if !avatarImageURL.isEmpty{
            avatarImageURL.remove(at: avatarImageURL.startIndex)
            cell.avatarImage.loadImage(fromURL: avatarImageURL)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == arrReview.results!.count - 5){
            currentPageReview += 1
            fetchUserReviewNextPage()
        }
    }
}
