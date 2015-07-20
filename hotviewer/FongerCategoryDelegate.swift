//
//  FongerCategoryDelegate.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/20.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation
import UIKit

protocol FongerCategoryDelegate {
    func categoryView(tableView: UITableView, selected: Bool, didSelectedChangeCategoryAtIndexPath indexPath: NSIndexPath)
    func categoryView(tableView: UITableView, itemForCategoryAtIndexPath indexPath: NSIndexPath) -> FongerCategoryItem
    func categoryView(tableView: UITableView, numberOfCategoriesInSection section: Int) -> Int
}