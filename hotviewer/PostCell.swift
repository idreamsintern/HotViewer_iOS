//
//  PostCell.swift
//  hotviewer
//
//  Created by AndyChen on 2015/7/16.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet weak var thumbanilImageView: UIImageView!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var title: UILabel!
    let loadingText = "載入中..."

    private var _thumbnailURL: NSURL!
    var thumbnailURL: NSURL? {
        get {
            return self._thumbnailURL
        }
        set(url) {
            if let url = url {
                SimpleCache.sharedInstance.getImage(url) { image, error in
                    if let err = error {
                        println(err)
                    } else if let fullImage = image {
                        self.thumbanilImageView.image = fullImage
                        self._thumbnailURL = url
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        content.text = loadingText
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        if let url = self.thumbnailURL {
            SimpleCache.sharedInstance.cancelImage(thumbnailURL)
        }
        thumbanilImageView.image = nil
        content.text = loadingText
    }
    
}

