//
//  Extensions.swift
//  CoreDataDemo
//
//  Created by A. Diallo on 6/14/19.
//  Copyright © 2019 Abdoulaye Diallo. All rights reserved.
//

import UIKit

//MARK: - UIColor

extension UIColor {
    
    static let someColor =  UIColor(red: 0,  green: 0, blue: 0, alpha: 1)
    static let tealColor = UIColor(red: 48/255, green: 164 / 255, blue: 182 / 255, alpha: 1.0)
    static let lightRed = UIColor(red: 247/255, green: 66/255, blue: 82/255, alpha: 1)
    static let darkblue = UIColor(red: 9 / 255, green: 45 / 255, blue: 64 / 255, alpha: 1.0)
    static let lightBlue = UIColor(red:  218 / 255, green: 235 / 255, blue: 243 / 255, alpha: 1.0)
}


//MARK: - UIViewController
extension UIViewController {
    
    fileprivate func setupNavigationStyle() {
        navigationController?.navigationBar.backgroundColor = .red
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .lightRed
        navigationItem.title = "Companies"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor  : UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor  : UIColor.white]
    }
    
}
