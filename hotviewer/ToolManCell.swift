//
//  ToolManCell.swift
//  hotviewer
//
//  Created by AndyChen on 2015/7/25.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import UIKit

protocol MatchButtonDelegate {
    func iDoClick(numberOfRow: Int)
}

class ToolManCell: UITableViewCell {

    @IBOutlet weak var thumbanilImageView: UIImageView!
    @IBOutlet weak var iAlsoDoButton: UIButton!
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

    
    @IBAction func IAlsodo(sender: UIButton) {
        delegate?.iDoClick(iAlsoDoButton.tag)
    }
    
    
}