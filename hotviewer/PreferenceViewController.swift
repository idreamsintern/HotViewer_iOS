//
//  PreferenceViewController.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/19.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation
import UIKit
class PTTPrefViewController : PreferenceViewController {
    
}

class PreferenceViewController : UIViewController, FongerCategoryDelegate {
    @IBOutlet weak var prefTableView: FongerCategoryTableView?
    
    var selectedCount = 0
    private var _categories = [FongerCategoryItem(text: "Not Set", imageNamed: "")]
    var categories: [FongerCategoryItem] {
        get {
            return _categories
        }
        set(newCategories) {
            _categories = newCategories
            prefTableView?.reloadData()
        }
    }
    var atLeastOneSelected: Bool {
        get {
            return selectedCount != 0
        }
    }
    var selectedCategories: [FongerCategoryItem] {
        get {
            var selected = [FongerCategoryItem]()
            for category in _categories {
                if category.selected {
                    selected.append(category)
                }
            }
            return selected
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        prefTableView?.categoryDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Total Category Count
    func categoryView(tableView: UITableView, numberOfCategoriesInSection section: Int) -> Int {
        return _categories.count
    }
    
    // Populate Category View
    func categoryView(tableView: UITableView, itemForCategoryAtIndexPath indexPath: NSIndexPath) -> FongerCategoryItem {
        // Get the item
        var item = _categories[indexPath.row]
        
        // Set item selected (default false)
        //item.selected = true
        
        return item
    }
    
    // Category selection change
    func categoryView(tableView: UITableView, selected: Bool, didSelectedChangeCategoryAtIndexPath indexPath: NSIndexPath) {
        _categories[indexPath.row].selected = selected
        if selected {
            self.selectedCount++
        } else {
            self.selectedCount--
        }
        println("No.\(indexPath.row) \(categories[indexPath.row].text) \(selected)")
    }
}
