//
//  UserReviewTableViewCell.swift
//  Alfagift-TechnicalTest
//
//  Created by Vincent on 28/02/23.
//

import UIKit

class UserReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var contentReviewText: UITextView!
    @IBOutlet weak var rateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
