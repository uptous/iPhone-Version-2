//
//  InviteCell.swift
//  uptous
//
//  Created by Roshan Gita  on 12/2/16.
//  Copyright © 2016 SPA. All rights reserved.
//

import UIKit

protocol InviteCellDelegate {
    func inviteAccept(_: NSInteger)
}


class InviteCell: UITableViewCell {

    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var inviteLbl: UILabel!
    var delegate: InviteCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //acceptBtn.layer.borderColor = UIColor(red: CGFloat(0.8), green: CGFloat(0.8), blue: CGFloat(0.8), alpha: CGFloat(1)).cgColor
        acceptBtn.layer.borderWidth = CGFloat(1.0)
        acceptBtn.layer.cornerRadius = 16.0
    }
    
    func updateData(_ data: Invite) {
        
        inviteLbl.text = data.communityName!
    }
    
    @IBAction func invite(_ sender: UIButton) {
        delegate.inviteAccept(sender.tag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
