//
//  AddIndicatorView.swift
//  hotviewer
//
//  Created by 傑瑞 on 2015/7/18.
//  Copyright (c) 2015年 傑瑞. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func getIndicatorView() -> UIActivityIndicatorView {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        indicatorView.center = self.view.center
        indicatorView.color = UIColor.grayColor()
        self.view.addSubview(indicatorView)
        return indicatorView
    }
}