//
//  Car.swift
//  HWlesson32
//
//  Created by Карина Дьячина on 18.05.24.
//

import Foundation
import RealmSwift

class Car: Object {
    @objc dynamic var brand = ""
    @objc dynamic var model = ""
    @objc dynamic var color = ""
    @objc dynamic var year = ""
}
