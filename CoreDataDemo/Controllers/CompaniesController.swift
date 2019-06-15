//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by A. Diallo on 6/14/19.
//  Copyright © 2019 Abdoulaye Diallo. All rights reserved.
//

import UIKit
import CoreData

class CompaniesController: UITableViewController, CreateCompanyControllerDelegate {
    
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    
    let CellID = "CompaniesControllerCellID"
    
    
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        navigationItem.title = "Companies"
        self.tableView.backgroundColor = .darkblue
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.tableView.register(CompanyCell.self, forCellReuseIdentifier: CellID)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAdd))
        
        fetchData()
        
    }
    //MARK: - Custom Functions.
    
    fileprivate  func fetchData(){
        
        let persistentContainer = NSPersistentContainer(name: "CoreDataDemo")
        persistentContainer.loadPersistentStores { (storeDesc, error) in
            if let err = error {
                print("Can't load the persistent store: \(err)")
            }
            let context = persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
            
        
            do{
               let companies = try context.fetch(fetchRequest)
                companies.forEach({ (company) in
                    print(company.name!)
                })
                
            }catch let fetchError {
                fatalError("Can't fetch the data: \(fetchError)")
            }
        }
    }
        @objc fileprivate func handleAdd(){
            let createController = CreateController()
            createController.delegate = self
            let createNavController = CustomNavigationController(rootViewController: createController)
            present(createNavController, animated: true, completion: nil)
        }
        
        
        override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let header = UIView()
            header.backgroundColor = .lightBlue
            return header
        }
        
        override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
        }
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return  companies.count
        }
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath) as! CompanyCell
            let company = companies[indexPath.item]
            cell.companyLabel.text = company.name
            return cell
        }
}

