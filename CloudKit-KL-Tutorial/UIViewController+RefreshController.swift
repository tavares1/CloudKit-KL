//
//  UIViewController+RefreshController.swift
//  CloudKit-KL-Tutorial
//
//  Created by Lucas Tavares on 29/01/19.
//  Copyright © 2019 Lucas Tavares. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func createRefreshControl (title: String, action: Selector) -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: action, for: .valueChanged)
        return refreshControl
    }
}
