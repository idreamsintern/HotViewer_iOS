//
//  PrincessCell.swift
//  hotviewer
//
//  Created by AndyChen on 2015/7/25.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import UIKit

class PrincessCell: UITableViewCell {
    @IBOutlet weak var thumbanilImageView: UIImageView!
    @IBOutlet weak var iDoButton: UIButton!
    var delegate: MatchButtonDelegate?
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
    
    @IBAction func IDo(sender: UIButton) {
        delegate?.iDoClick(iDoButton.tag)
    }
    @IBOutlet weak var request: UILabel!
}