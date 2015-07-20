//
//  PreferenceViewController.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/19.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation
import UIKit

class PreferenceViewController : UIViewController, FongerCategoryDelegate {
    @IBOutlet weak var prefTableView: FongerCategoryTableView!
    
    var prefCategories =
    [
        FongerCategoryItem(text: "Technology", imageNamed: "technology"),
        FongerCategoryItem(text: "Food", imageNamed: "food"),
        FongerCategoryItem(text: "Love", imageNamed: "love"),
        FongerCategoryItem(text: "Sex", imageNamed: "sex"),
        FongerCategoryItem(text: "Travel", imageNamed: "travel"),
        FongerCategoryItem(text: "Sport", imageNamed: "sport"),
        FongerCategoryItem(text: "Makeup", imageNamed: "makeup"),
        FongerCategoryItem(text: "Health", imageNamed: "health"),
        FongerCategoryItem(text: "Nature", imageNamed: "nature"),
        FongerCategoryItem(text: "Language", imageNamed: "language")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prefTableView.categoryDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Total Category Count
    func categoryView(tableView: UITableView, numberOfCategoriesInSection section: Int) -> Int {
        return prefCategories.count
    }
    
    // Populate Category View
    func categoryView(tableView: UITableView, itemForCategoryAtIndexPath indexPath: NSIndexPath) -> FongerCategoryItem {
        // Get the item
        var item = prefCategories[indexPath.row]
        
        // Set item selected (default false)
        //item.selected = true
        
        return item
    }
    
    // Category selection change
    func categoryView(tableView: UITableView, selected: Bool, didSelectedChangeCategoryAtIndexPath indexPath: NSIndexPath) {
        prefCategories[indexPath.row].selected = selected
        println("No.\(indexPath.row) \(prefCategories[indexPath.row].text) \(selected)")
    }
}
