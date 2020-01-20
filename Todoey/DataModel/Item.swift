//
//  Item.swift
//  Todoey
//
//  Created by Oleg Kudimov on 1/16/20.
//  Copyright © 2020 Oleg Kudimov. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date? 
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
