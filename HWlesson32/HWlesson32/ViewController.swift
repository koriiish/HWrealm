//
//  ViewController.swift
//  HWlesson32
//
//  Created by Карина Дьячина on 7.04.24.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    var cars: [Car] {
        RealmManager.shared.cars
    }
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigation()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.reloadData()
        
    }
    
    func setupNavigation() {
        let addCarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addCarButton
    }
    
    @objc func addButtonTapped() {
        showAlert()
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Add car", message: "Save your favourite cars", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            // cars.brand = textField.text ?? "brand"
            textField.placeholder = "Brand"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Model"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Color"
        }
        
        alertController.addTextField { textField in
            textField.placeholder = "Year"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self]_ in
            print("ok")
            guard let textFields = alertController.textFields,
                  textFields.count > 3,
                  let brandToSave = textFields[0].text,
                  let modelToSave = textFields[1].text,
                  let colorToSave = textFields[2].text,
                  let yearToSave = textFields[3].text else {
                return
            }
            self?.addCar(brandToSave, modelToSave, colorToSave, yearToSave)
        }
        
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func addCar( 
        _ brand: String,
        _ model: String,
        _ color: String,
        _ year: String
    ) {
        RealmManager.shared.addCar(
            brand: brand,
            model: model,
            color: color,
            year: year
        ) { [weak self] in
            self?.tableView.reloadData()
        }
        
    }
    
    private func presentFailureAlert(_ message: String) {
        let alert = UIAlertController(title: "Failure", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let car = cars[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath)
        cell.textLabel?.text = car.brand
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            RealmManager.shared.delete(at: indexPath.row) { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < cars.count else { return }
        let myCar = cars[indexPath.row]
        
        let message = """
                Car brand: \(myCar.brand)
                Car model: \(myCar.model)
                Car color: \(myCar.color)
                Car year: \(myCar.year)
                """
        
        let alert = UIAlertController(title: myCar.brand,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
}
