//
//  FongerCategoryTableView.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/20.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation
import UIKit

class FongerCategoryTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    var reuseIdentifier = "categoryCell"
    var categoryDelegate: FongerCategoryDelegate?
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Make sure zero span to TableView
        self.layoutMargins = UIEdgeInsetsZero;
        self.delegate = self
        self.dataSource = self
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryDelegate?.categoryView(tableView, numberOfCategoriesInSection: section) ?? 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.reuseIdentifier) as? FongerCategoryCell
        cell?.delegate = self.categoryDelegate
        if let item = self.categoryDelegate?.categoryView(tableView, itemForCategoryAtIndexPath: indexPath) {
            cell?.button.setTitle(item.text, forState: UIControlState.Normal)
            cell?.button.setBackgroundImage(UIImage(named: item.imageNamed), forState: UIControlState.Normal)
            cell?.button.alpha = item.selected ? 1.0 : 0.4
            cell?.button.selected = item.selected
        }
        return cell!
    }
}