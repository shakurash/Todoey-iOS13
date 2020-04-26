//
//  ControlerListModel.swift
//  Todoey
//
//  Created by Robert on 23/04/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class ControlerListModel: Object {
    @objc dynamic var item: String = ""
    var items = List<TodoListModel>()
}
