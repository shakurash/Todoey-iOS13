import Foundation
import RealmSwift

class ControlerListModel: Object {
    @objc dynamic var item: String = ""
    @objc dynamic var cellColor: String = "White"
    var items = List<TodoListModel>()
}
