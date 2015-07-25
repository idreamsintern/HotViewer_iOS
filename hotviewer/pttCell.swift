//
//  pttCell.swift
//  hotviewer
//
//  Created by AndyChen on 2015/7/20.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import UIKit

class pttCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var board: UILabel!
    @IBOutlet weak var push: UILabel!
    //@IBOutlet weak var thumbnailmageView: UIImageView!
    @IBOutlet weak var pushImageView: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
