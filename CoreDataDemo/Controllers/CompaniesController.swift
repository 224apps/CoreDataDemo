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
        
        fetchCompanies()
        
    }
    
    //MARK: - Protocol Delegates
    
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func didEditCompany(company: Company) {
        let row = companies.index(of: company)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        self.tableView.reloadRows(at: [reloadIndexPath], with: .right)
    }
    
    //MARK: - Custom Functions.
    
    fileprivate  func fetchCompanies(){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        do{
            let companies = try context.fetch(fetchRequest)
            self.companies = companies
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch let fetchError {
            fatalError("Can't fetch the data: \(fetchError)")
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
        
        if let name = company.name, let founded = company.founded {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM dd, yyyy"
            let dateFormattedString = dateFormatter.string(from: founded)
            let dateString = "\(name),- Founded:\( dateFormattedString)"
            cell.companyLabel.text = dateString
        }
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction =  UITableViewRowAction(style: .default, title: "Delete", handler:deleteActionHandler)
        deleteAction.backgroundColor = .lightRed
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editActionHandler)
        editAction.backgroundColor = .darkblue
        return  [editAction, deleteAction]
    }
    
    
    private func deleteActionHandler(_  action: UITableViewRowAction,_ indexPath: IndexPath){
        let company = self.companies[indexPath.item]
        self.companies.remove(at: indexPath.item)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.delete(company)
    }
    
    private func editActionHandler(_ action: UITableViewRowAction, _ ndexPath: IndexPath){
        let editCompanyNavController = CustomNavigationController(rootViewController:  CreateController())
        present(editCompanyNavController, animated: true, completion: nil)
    }
}

