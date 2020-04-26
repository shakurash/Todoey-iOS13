import UIKit
import RealmSwift

class CategoryTableViewController: SharedCellFuncionality {

    var controlerArray: Results<ControlerListModel>?
    //lazy var realm = try? Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

 //MARK: - Controler table view setup

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controlerArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = "\(controlerArray?[indexPath.row].item ?? "No category being set")"
        return cell
    }
    
    //MARK: - Controller bar button functionality setup
    
    @IBAction func barAddButton(_ sender: UIBarButtonItem) {
        
        var message = UITextField()
        
        let alert = UIAlertController(title: K.alertTitle, message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: K.barActionButton, style: .default) { (actionHandler) in
            
            if let safeMessage = message.text {
                let item = ControlerListModel()
                item.item = safeMessage
                self.saveData(data: item)
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
     
    func saveData(data: ControlerListModel){
             do {
                try? realm.write{
                    realm.add(data)
                }
             }catch {
                 print(error)
             }
        
         tableView.reloadData()
     }
    
     func loadData(){
        controlerArray = realm.objects(ControlerListModel.self)
         tableView.reloadData()
     }

    //MARK: - Behaviour of selected row
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segueTodoListName, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = controlerArray?[indexPath.row]
        }
    }
    
  
//MARK: - Swipe functions
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Skasuj", handler: { (action, view, completionHandler) in

            if let arrayForDelete = self.controlerArray?[indexPath.row] {
                super.deletingCell(arrayForDelete: arrayForDelete)
            }
            tableView.reloadData()
            completionHandler(true)
           })
        deleteAction.backgroundColor = .red
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }    
    }

