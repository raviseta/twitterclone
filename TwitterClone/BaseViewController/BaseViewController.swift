//
//  BaseViewController.swift
//  TwitterClone
//
//  Created by raviseta on 01/03/23.
//

import UIKit

class BaseViewController: UIViewController {
    // Put all stuffs which are common to all viewControllers
    func setNavigationAppearance(title: String) {
        self.navigationItem.title = title
    }
}
