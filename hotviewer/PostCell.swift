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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

