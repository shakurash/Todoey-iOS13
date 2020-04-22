import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var selectedCategory: ControlerListModel? {
        didSet { loadData()
        }
    }
    var itemArray = [TodoListModel]()
   // let todoListURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(K.list.plistName)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //MARK: - Setup the view of TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.todoReusableCell, for: indexPath)
        cell.textLabel?.text = "\(itemArray[indexPath.row].title!)"
        
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        
        return cell
        }
    
    //MARK: - Behaviour of selected row
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveData()
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Bar button functionality setup
    
    @IBAction func barAddButton(_ sender: UIBarButtonItem) {
        
        var message = UITextField()
        
        let alert = UIAlertController(title: K.alertTitle, message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: K.barActionButton, style: .default) { (actionHandler) in
            
            if let safeMessage = message.text {
                let item = TodoListModel(context: self.context)
                item.title = safeMessage
                item.done = false
                item.todoToControlerModel = self.selectedCategory
                self.itemArray.append(item)
            self.saveData()
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = K.actionPlaceHolder
            message = textField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data methods
    
    func saveData(){
            do {
                try context.save()
            } catch {
                print(error)
            }
        tableView.reloadData()
    }

// MARK: - Search bar manager (delegate = self <- zrobiony poprzez main.storyboard

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            let request: NSFetchRequest<TodoListModel> = TodoListModel.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        let sortList = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortList]
        loadData(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
        loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
