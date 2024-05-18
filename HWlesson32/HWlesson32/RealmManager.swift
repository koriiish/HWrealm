//
//  RealmManager.swift
//  HWlesson32
//
//  Created by Карина Дьячина on 18.05.24.
//

import Foundation
import RealmSwift


class RealmManager {
    
    private init() { }
    static let shared = RealmManager()
    
    
    var cars: [Car] = []
    
    lazy var realm: Realm? = {
        do {
            let _realm = try Realm()
            return _realm
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }()
    
//        func save(brand: String, model: String, color: String, year: String, completion: () -> ()) {
//            let carObject = Car(brand: brand, model: model, color: color, year: year)
//            guard let realm else {
//                return
//            }
//    
//            do {
//                try realm.write {
//                    realm.add(carObject)
//                }
//                cars.append(carObject)
//            } catch {
//                print(error.localizedDescription)
//            }
//    
//            completion()
//        }
//    
//        func delete(at index: Int, completion: () -> ()) {
//            guard let realm else {
//                return
//            }
//    
//            do {
//                let deletingCar = realm.object(ofType: Car.self, forPrimaryKey: id)
//                guard let deletingCar else {
//    
//                    return
//                }
//                try realm.write {
//                    realm.delete(deletingCar)
//                    cars.remove(at: indexPath.row)
//                }
//    
//            } catch {
//                print(error.localizedDescription)
//            }
//    
//            completion()
//        }
//    
//        func readCar(id: ObjectId) -> Car {
//                guard let realm = RealmManager.shared.realm else {
//    
//                    return Car(brand: "No car", model: "-", color: "-", year: "-")
//                }
//    
//                return realm.object(ofType: Car.self, forPrimaryKey: id) ?? Car(brand: "No car", model: "-", color: "-", year: "-")
//            }
//    
//            func readAllCarsFromDatabase() {
//                guard let realm else {
//                    return
//                }
//                cars = realm.objects(Car.self).map { $0 }
//            }
        }

