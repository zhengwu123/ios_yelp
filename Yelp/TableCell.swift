//
//  TableCell.swift
//  Yelp
//
//  Created by New on 2/4/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class TableCell: UITableViewCell {

    @IBOutlet var foodType: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var reviews: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var starimage: UIImageView!
    @IBOutlet var photoImage:UIImageView!
    
    var business: Business!{
    
        didSet{
        title.text = business.name
    
            photoImage.setImageWithURL((business.imageURL)!)
            foodType.text = business.categories
            distance.text = business.distance
            reviews.text = "\(business.reviewCount!) reviews"
            starimage.setImageWithURL(business.ratingImageURL!)
            addressLabel.text = business.address
        }
    
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoImage.layer.cornerRadius = 5
        photoImage.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
