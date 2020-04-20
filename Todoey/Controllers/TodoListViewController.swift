import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [TodoListModel]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem1 = TodoListModel(title: "buy milk", done: false)
        let newItem2 = TodoListModel(title: "do something", done: false)
        let newItem3 = TodoListModel(title: "destroy the world", done: false)
        itemArray.append(contentsOf: [newItem1, newItem2, newItem3])
        
//        if let item = defaults.array(forKey: K.defaults.arrayKey) as? [String] {
//
//        }
    }

    //MARK: - Setup the view of TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.reusableCellName, for: indexPath)
        cell.textLabel?.text = "\(itemArray[indexPath.row])"
            return cell
        }
    
    //MARK: - Behaviour of selected row
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Bar button functionality setup
    
    @IBAction func barAddButton(_ sender: UIBarButtonItem) {
        
        var message = UITextField()
        
        let alert = UIAlertController(title: K.alertTitle, message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: K.barActionButton, style: .default) { (actionHandler) in
           //     self.itemArray.append(message.text!)
            self.defaults.set(self.itemArray, forKey: K.defaults.arrayKey)
                self.tableView.reloadData()
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = K.actionPlaceHolder
            message = textField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
   
}

