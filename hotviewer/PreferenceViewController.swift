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
    
    var categories = [
        [
            FongerCategoryItem(text: "No category", imageNamed: "")
        ],
        [
            FongerCategoryItem(text: "Food", imageNamed: "food", tag: "food"),
            FongerCategoryItem(text: "Love", imageNamed: "love", tag: "boy-girl"),
            FongerCategoryItem(text: "Sex", imageNamed: "sex", tag: "sex"),
            FongerCategoryItem(text: "Travel", imageNamed: "travel", tag: "travel"),
            FongerCategoryItem(text: "Fitness", imageNamed: "sport", tag: "fitness"),
            FongerCategoryItem(text: "Technology", imageNamed: "technology", tag: "tech_job"),
            FongerCategoryItem(text: "Makeup", imageNamed: "makeup", tag: "makeup"),
            FongerCategoryItem(text: "Health", imageNamed: "health", tag: "health"),
            FongerCategoryItem(text: "Nature", imageNamed: "nature", tag: "geography"),
            FongerCategoryItem(text: "Language", imageNamed: "language", tag: "language")
        ],
        [
            FongerCategoryItem(text: "No category", imageNamed: "")
        ]
    ]
    
    var selectedCount = 0
    private var _articleTypeIndex: Int = 0
    var articleTypeIndex: Int {
        get {
            return _articleTypeIndex
        }
        set(newVal) {
            _articleTypeIndex = newVal
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
            for category in categories[articleTypeIndex] {
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
        return categories[_articleTypeIndex].count
    }
    
    // Populate Category View
    func categoryView(tableView: UITableView, itemForCategoryAtIndexPath indexPath: NSIndexPath) -> FongerCategoryItem {
        // Get the item
        var item = categories[_articleTypeIndex][indexPath.row]
        
        // Set item selected (default false)
        //item.selected = true
        
        return item
    }
    
    // Category selection change
    func categoryView(tableView: UITableView, selected: Bool, didSelectedChangeCategoryAtIndexPath indexPath: NSIndexPath) {
        categories[_articleTypeIndex][indexPath.row].selected = selected
        if selected {
            self.selectedCount++
        } else {
            self.selectedCount--
        }
        println("No.\(indexPath.row) \(categories[_articleTypeIndex][indexPath.row].text) \(selected)")
    }
}
