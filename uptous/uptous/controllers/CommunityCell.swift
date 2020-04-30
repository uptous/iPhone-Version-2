//
//  CommunityCell.swift
//  uptous
//
//  Created by Roshan Gita  on 11/13/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit

protocol CommunityCellDelegate {
    func communitySelected(_: NSInteger)
}

class CommunityCell: UITableViewCell {
    
    @IBOutlet weak var communityNameLbl: UILabel!
    var delegate: CommunityCellDelegate!

    @IBOutlet weak var communityBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func communityClick(_ sender: UIButton) {
        delegate.communitySelected(sender.tag)
    }
    func update(_ data: Community) {
        communityNameLbl.text = data.name!
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
