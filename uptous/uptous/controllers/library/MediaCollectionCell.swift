//
//  MediaCollectionCell.swift
//  uptous
//
//  Created by Roshan Gita  on 11/10/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

class MediaCollectionCell: UICollectionViewCell {

    @IBOutlet weak var thumnnailv : UIImageView!
    @IBOutlet weak var activityindicator : UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        thumnnailv.layer.borderColor = UIColor.lightGray.cgColor
//        thumnnailv.layer.borderWidth = 1.5
//        thumnnailv.layer.cornerRadius = 10.0
    }
    

}
