//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by A. Diallo on 6/14/19.
//  Copyright © 2019 Abdoulaye Diallo. All rights reserved.
//

import UIKit

class CompaniesController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupNavigationStyle()
    }
    
    //MARK: - Custom Functions.
    fileprivate func setupNavigationStyle() {
        let lightRed = UIColor(red: 247/255, green: 66/255, blue: 82/255, alpha: 1)
        navigationController?.navigationBar.backgroundColor = .red
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = lightRed
        navigationItem.title = "Companies"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: #selector(handleAdd), action: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor  : UIColor.white]
    }
    
    @objc fileprivate func handleAdd(){
        print("Adding a company")    }
}

