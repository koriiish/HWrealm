//
//  ViewController.swift
//  HWlesson32
//
//  Created by Карина Дьячина on 7.04.24.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    var cars: [Car] = []
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var realm: Realm? = {
        do {
            let _realm = try Realm()
            return _realm
        } catch {
            print(error.localizedDescription)
            return nil
        }
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
        
        guard let realm else {
            presentFailureAlert("Cant get saved values")
            return
        }
        
        cars = realm.objects(Car.self).map{$0}
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
    
    private func addCar(_ brand: String, _ model: String, _ color: String, _ year: String) {
        let carObject = Car(brand: brand, model: model, color: color, year: year)
        carObject.id = UUID().uuidString
        guard let realm else {
            presentFailureAlert("Something went wrong with database....")
            return
        }
        
        do {
            try realm.write {
                realm.add(carObject)
            }
            self.cars.append(carObject)
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
            presentFailureAlert(error.localizedDescription)
        }
        tableView.reloadData()
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
        car.value(forKeyPath: "brand") as? String
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
            guard let realm,
                  cars.count > indexPath.row else { return }
            let carId = cars[indexPath.row].id
            
            do {
                let delitingCar = realm.object(ofType:Car.self, forPrimaryKey: carId)
                guard let delitingCar else {
                    presentFailureAlert("Cant identify the car")
                    return
                }
                try realm.write {
                    realm.delete(delitingCar)
                    self.cars.remove(at: indexPath.row)
                    tableView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
                presentFailureAlert(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var myCar: Car?
        
        let message = """
                Car brand: \(myCar?.brand ?? "I dont know brand")
                Car model: \(myCar?.model ?? "I dont know model")
                Car color: \(myCar?.color ?? "I dont know color"))
                Car year: \(myCar?.year ?? "I dont know year"))
                """
        
        let alert = UIAlertController(title: myCar?.brand,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
}
