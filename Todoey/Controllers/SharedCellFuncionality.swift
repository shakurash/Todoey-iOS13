import UIKit
import RealmSwift

class SharedCellFuncionality: UITableViewController {

    lazy var realm = try! Realm()
    
    func deletingCell(arrayForDelete: ControlerListModel? = nil, arrayForDelete2: TodoListModel? = nil) {
        do{
        try self.realm.write{
            if let model = arrayForDelete {
                self.realm.delete(model)
            } else {
                self.realm.delete(arrayForDelete2!)
            }
        }
        } catch {
            print(error)
        }
    }
    
//MARK: - Tableview setup
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCell, for: indexPath)
        return cell
    }
}





