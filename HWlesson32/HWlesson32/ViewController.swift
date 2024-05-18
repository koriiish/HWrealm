//
//  ViewController.swift
//  HWlesson32
//
//  Created by Карина Дьячина on 7.04.24.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    
    
    var realm : Realm!
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var carsList: Results<Car> {
        get {
            return realm.objects(Car.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigation()
        
        realm = try! Realm()
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
        
//        alertController.addTextField { textField in
//            self.brandToSave = textField.text ?? "brand"
//            textField.placeholder = "Brand"
//        }
//        
//        alertController.addTextField { textField in
//            self.modelToSave = textField.text ?? "model"
//            textField.placeholder = "Model"
//        }
//        
//        alertController.addTextField { textField in
//            self.colorToSave = textField.text ?? "color"
//            textField.placeholder = "Color"
//        }
//        
//        alertController.addTextField { textField in
//            self.yearToSave = textField.text ?? "year"
//            textField.placeholder = "Year"
//        }
        let car = Car()
        try! self.realm.write({
            self.realm.add(car)    // (9)
            self.tableView.insertRows(at: [IndexPath.init(row: self.carsList.count-1, section: 0)], with: .automatic)
        })
        
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return RealmManager.shared.cars.count
        return carsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
        //                                            for: indexPath)
        //        cell.textLabel?.text = carsArray[indexPath.row]
        //        return cell
        //
       // let car = RealmManager.shared.cars[indexPath.row]
        let car = carsList[indexPath.row]
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
        if (editingStyle == .delete){
          //  let item = RealmManager.shared.cars[indexPath.row]
            let item = carsList[indexPath.row]
            try! self.realm.write({
                self.realm.delete(item)
            })
            tableView.deleteRows(at:[indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = carsList[indexPath.row]
        try! self.realm.write({     // (6)
            item.brand = item.brand
        })
        //refresh rows
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
