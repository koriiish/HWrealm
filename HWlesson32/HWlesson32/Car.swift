//
//  Car.swift
//  HWlesson32
//
//  Created by Карина Дьячина on 18.05.24.
//

import Foundation
import RealmSwift

class Car: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var brand: String
    @Persisted var model: String
    @Persisted var color: String
    @Persisted var year: String
    
    convenience init(brand: String, model: String, color: String, year: String) {
        self.init()
        
        self.brand = brand
        self.model = model
        self.color = color
        self.year = year
    }
}
