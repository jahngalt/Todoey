//
//  Category.swift
//  Todoey
//
//  Created by Oleg Kudimov on 1/16/20.
//  Copyright © 2020 Oleg Kudimov. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = "" 
    let items = List<Item>()  
}
