import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SharedCellFuncionality {

    @IBOutlet weak var searchBar: UISearchBar!

    var selectedCategory: ControlerListModel? {
        didSet { loadData()
        }
    }
    var itemArray: Results<TodoListModel>?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        if let safeCategory = selectedCategory {
            if let safeColor = UIColor(hexString: safeCategory.cellColor) {
                navigationController?.navigationBar.tintColor = ContrastColorOf(safeColor, returnFlat: true)
                navigationController?.navigationBar.barTintColor = safeColor
                title = safeCategory.item
                searchBar.barTintColor = safeColor
                UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(safeColor, returnFlat: true)]
            }
        }
    }
    //MARK: - Setup the view of TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
       
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = "\(item.title)"
            cell.accessoryType = item.done == true ? .checkmark : .none
            if let safeCategory = selectedCategory?.cellColor {
                if let color = UIColor(hexString: safeCategory) {
                    cell.backgroundColor = color.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(itemArray!.count))
                    cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
                }
            }
        }
        
        return cell
        }
    
    //MARK: - Behaviour of selected row
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row] {
        do {
        try self.realm.write{
            item.done = !item.done
        }
        } catch {
            print(error)
        }
        tableView.reloadData()
        }
    }
    
    //MARK: - Bar button functionality setup
    
    @IBAction func barAddButton(_ sender: UIBarButtonItem) {
        
        var message = UITextField()
        
        let alert = UIAlertController(title: K.alertTitle, message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: K.barActionButton, style: .default) { (actionHandler) in
            
            if let safeMessage = message.text {
                do {
                try self.realm.write{
                let item = TodoListModel()
                item.title = safeMessage
                item.time = Date()
                self.selectedCategory?.items.append(item)
                }
                } catch {
                    print(error)
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = K.actionPlaceHolder
            message = textField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func loadData(){
        itemArray = selectedCategory?.items.sorted(byKeyPath: "time", ascending: true)
        tableView.reloadData()
        
    }
    }


// MARK: - Search bar manager (delegate = self <- zrobiony poprzez main.storyboard

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
        loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    //MARK: - Swipe functions
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Skasuj", handler: { (action, view, completionHandler) in

            if let arrayForDelete = self.selectedCategory?.items[indexPath.row] {
                super.deletingCell(arrayForDelete2: arrayForDelete)
            }
            tableView.reloadData()
            completionHandler(true)
           })
        deleteAction.backgroundColor = .red
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
}
