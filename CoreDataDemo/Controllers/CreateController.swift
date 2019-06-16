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
    func didEditCompany(company: Company)
}

class CreateController: UIViewController {
    
    
    
    var delegate: CreateCompanyControllerDelegate?
    //  var companiesController: CompaniesController?
    
    var company: Company? {
        didSet {
            nameTextField.text =  company?.name
            guard let founded = company?.founded  else { return }
            datePicker.date = founded
        }
    }
    
    let lightBackgroundView: UIView = {
        let lbv = UIView()
        lbv.backgroundColor = .lightBlue
        lbv.translatesAutoresizingMaskIntoConstraints = false
        return lbv
    }()
    
    
    lazy var companyImageView: UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "select_photo_empty")
        imv.contentMode = .scaleAspectFit
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.isUserInteractionEnabled = true
        imv.layer.cornerRadius = 16
        imv.layer.masksToBounds = true
        imv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        return imv
    }()
    
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = " Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = " Enter name"
        txtField.translatesAutoresizingMaskIntoConstraints = false
        
        return txtField
    }()
    
    let datePicker: UIDatePicker  = {
        let dp = UIDatePicker()
        dp.datePickerMode = UIDatePicker.Mode.date
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        view.backgroundColor = .darkblue
        // navigationItem.title = "Create Company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title =  company == nil ? "Create Company": "Edit Company"
    }
    
    //MARK: - Custom Functions.
    
    fileprivate func setupUI(){
        view.addSubview(lightBackgroundView)
        
        NSLayoutConstraint.activate([
            lightBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            lightBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            lightBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            lightBackgroundView.heightAnchor.constraint(equalToConstant: 350)
            ])
        
        view.addSubview(companyImageView)
        
        NSLayoutConstraint.activate([
            companyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            companyImageView.widthAnchor.constraint(equalToConstant: 100),
            companyImageView.heightAnchor.constraint(equalToConstant: 100)
            ])
        
        
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant:  20),
            nameLabel.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        view.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo:  nameLabel.topAnchor),
            nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor),
            nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        view.addSubview(datePicker)
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo:  nameLabel.bottomAnchor),
            datePicker.rightAnchor.constraint(equalTo: view.rightAnchor),
            datePicker.leftAnchor.constraint(equalTo: view.leftAnchor),
            datePicker.bottomAnchor.constraint(equalTo: lightBackgroundView.bottomAnchor)
            ])
        
    }
    
    @objc fileprivate func handleSelectPhoto(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    @objc fileprivate func handleCancel(){
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleSave(){
        if  company == nil {
            createCompany()
        } else {
            saveCompanyChanges()
        }
    }
    
    fileprivate func saveCompanyChanges (){
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        company?.name = nameTextField.text
        company?.founded = datePicker.date
        
        do {
            try context.save()
        } catch {
            fatalError("Can't Save the changed company name in the context")
        }
        dismiss(animated: true) {
            self.delegate?.didEditCompany(company: self.company!)
        }
        
    }
    
    fileprivate func createCompany(){
        guard let name = self.nameTextField.text else { return }
        let date = self.datePicker.date
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        company.setValue(name, forKey: "name")
        company.setValue(date, forKey: "founded")
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


//MARK: ImagePickerController

extension CreateController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let  editedImage = info [UIImagePickerController.InfoKey.editedImage] as? UIImage {
            companyImageView.image = editedImage
        }else if let  originalPhoto = info [UIImagePickerController.InfoKey.originalImage] as? UIImage {
            companyImageView.image = originalPhoto
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
