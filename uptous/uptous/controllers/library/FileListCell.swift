//
//  FileListCell.swift
//  uptous
//
//  Created by Roshan Gita  on 12/4/16.
//  Copyright © 2016 UpToUs. All rights reserved.
//

import UIKit

protocol FileListCellDelegate {
    func downloadAndOpenFile(_: NSInteger)
}

//protocol FileListCellDelegate {
//   // func downloadAndOpenFile(_: Integer)
//}

class FileListCell: UITableViewCell {

    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var fileImgView: UIImageView!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var fileButton: UIButton!
    var delegate: FileListCellDelegate!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        customView.layer.borderColor = UIColor.lightGray.cgColor
        customView.layer.borderWidth = 1.5
        customView.layer.cornerRadius = 10.0
        fileNameLabel.numberOfLines = 0
    }
    
    func updateView(data: Files) {
        let docFile = data.path?.components(separatedBy: ".").last

        if docFile == "doc" || docFile == "docx" {
            fileImgView.image = UIImage(named: "word")
            fileNameLabel.text = data.title
            
        }else if docFile == "pdf" {
            fileImgView.image = UIImage(named: "pdf")
            fileNameLabel.text = data.title
            
        }else if docFile == "JPG" || docFile == "png"{
            fileImgView.image = UIImage(named: "ImageFile")
            fileNameLabel.text = data.title
            
        }else if docFile == "xls" || docFile == "xlsx" {
            fileImgView.image = UIImage(named: "excel")
            fileNameLabel.text = data.title
            
        }else if docFile == "MOV" || docFile == "MP3" || docFile == "mp3" {
            fileImgView.image = UIImage(named: "clipicon")
            fileNameLabel.text = data.title
            
        }else {
            fileImgView.image = UIImage(named: "ImageFile")
            fileNameLabel.text = data.title
            
        }
       
        
    }
    
    @IBAction func downloadFile(_ sender: UIButton) {
        delegate.downloadAndOpenFile(sender.tag)
    }
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
