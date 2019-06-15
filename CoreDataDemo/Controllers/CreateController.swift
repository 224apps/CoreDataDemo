//
//  CreateController.swift
//  CoreDataDemo
//
//  Created by A. Diallo on 6/14/19.
//  Copyright © 2019 Abdoulaye Diallo. All rights reserved.
//

import UIKit
import CoreData

//Create a custom Delegation
protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
}

class CreateController: UIViewController {
    
    
    var delegate: CreateCompanyControllerDelegate?
    //  var companiesController: CompaniesController?
    
    
    let lightBackgroundView: UIView = {
        let lbv = UIView()
        lbv.backgroundColor = .lightBlue
        lbv.translatesAutoresizingMaskIntoConstraints = false
        return lbv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = " Name"
        label.backgroundColor = .yellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = " Enter name"
        txtField.translatesAutoresizingMaskIntoConstraints = false
        
        return txtField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        view.backgroundColor = .darkblue
        navigationItem.title = "Create Company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
    }
    
    
    //MARK: - Custom Functions.
    
    fileprivate func setupUI(){
        view.addSubview(lightBackgroundView)
        
        NSLayoutConstraint.activate([
            lightBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            lightBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            lightBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            lightBackgroundView.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant:  20),
            nameLabel.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo:  view.topAnchor),
            nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor),
            nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    @objc fileprivate func handleCancel(){
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleSave(){
        //Initialization of coredatastack
        guard let name = self.nameTextField.text else { return }
           let context = CoreDataManager.shared.persistentContainer.viewContext
            let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
            company.setValue(name, forKey: "name")
            //save the context
            do {
                try context.save()
                self.dismiss(animated: true, completion: {
                    self.delegate?.didAddCompany(company: company as! Company)
                })
            } catch {
                print("Error. Failed to save company with error: \(error)")
            }
        }
    
}
