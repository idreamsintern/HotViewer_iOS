//
//  FongerCategoryCell.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/19.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//
import Foundation
import UIKit

class FongerCategoryCell: UITableViewCell {
    
    @IBOutlet weak var button: UIButton!
    var delegate: FongerCategoryDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.blackColor()
    }

    @IBAction func onButtonClick(sender: UIButton) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                self.button.selected = !self.button.selected
                self.button.alpha = self.button.selected ? 1.0 : 0.4
            }, completion: { finished in
                
        })
        
        UIView.animateWithDuration(0.1, delay: 0.0, options:
            UIViewAnimationOptions.Repeat | UIViewAnimationOptions.Autoreverse | UIViewAnimationOptions.AllowUserInteraction, animations: {
                UIView.setAnimationRepeatCount(1.5)
                var labelFrame : CGRect = self.button.titleLabel!.frame
                
                let originXbutton = labelFrame.origin.x
                let originYbutton = labelFrame.origin.y
                
                let originWidthbutton = labelFrame.size.width
                let originHeightbutton = labelFrame.size.height
                
                self.button.titleLabel!.frame = labelFrame
                self.button.titleLabel!.frame = CGRectMake(
                    originXbutton - 5,
                    originYbutton - 5,
                    originWidthbutton + 10,
                    originHeightbutton + 10)
                
                var tableView = self.superview
                while (tableView != nil && !(tableView is UITableView)) {
                    tableView = tableView?.superview
                }
                if let tableView = tableView as? UITableView, let indexPath = tableView.indexPathForCell(self) {
                    self.delegate?.categoryView(tableView, selected: self.button.selected, didSelectedChangeCategoryAtIndexPath: indexPath)
                }
            }, completion: { finished in

        })
    }
}
