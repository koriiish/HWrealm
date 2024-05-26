//
//  RealmManager.swift
//  HWlesson32
//
//  Created by Карина Дьячина on 18.05.24.
//

import Foundation
import RealmSwift


class RealmManager {
    
    private init() {
        readAllCarsFromDatabase()
    }
    static let shared = RealmManager()
    
    var cars: [Car] = []
    
    private var realm: Realm? = {
        do {
            let _realm = try Realm()
            return _realm
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }()
    
    func addCar(brand: String, model: String, color: String, year: String, completion: () -> ()) {
        guard let realm else {
            return
        }
        
        let carObject = Car(brand: brand, model: model, color: color, year: year)
        
        carObject.id = UUID().uuidString
        
        do {
            try realm.write {
                realm.add(carObject)
            }
            self.cars.append(carObject)
        } catch {
            print(error.localizedDescription)
        }
        
        completion()
    }
    
    func delete(at index: Int, completion: () -> ()) {
        guard let realm,
            index < cars.count
        else {
            return
        }
        
        guard index < cars.count else { return }
        let deletingCar = cars[index]
        
        do {
            try realm.write {
                realm.delete(deletingCar)
                cars.remove(at: index)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        completion()
    }
    
    func readAllCarsFromDatabase() {
        guard let realm else {
            return
        }
        cars = realm.objects(Car.self).map { $0 }
    }
}

