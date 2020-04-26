//
//  TodoListModel.swift
//  Todoey
//
//  Created by Robert on 23/04/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class TodoListModel: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var time: Date = Date()
    var parentData = LinkingObjects(fromType: ControlerListModel.self, property: "items")
}
