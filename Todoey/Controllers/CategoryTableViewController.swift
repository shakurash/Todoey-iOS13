import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var controlerArray = [ControlerListModel]() 
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

// MARK: - Controler table view setup
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controlerArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.controlerReusableCell, for: indexPath)
        cell.textLabel?.text = "\(controlerArray[indexPath.row].item!)"
        return cell
    }
    
    //MARK: - Controller bar button functionality setup
    
    @IBAction func barAddButton(_ sender: UIBarButtonItem) {
        
        var message = UITextField()
        
        let alert = UIAlertController(title: K.alertTitle, message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: K.barActionButton, style: .default) { (actionHandler) in
            
            if let safeMessage = message.text {
                let item = ControlerListModel(context: self.context)
                item.item = safeMessage
                self.controlerArray.append(item)
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
    
     func loadData(with request: NSFetchRequest<ControlerListModel> = ControlerListModel.fetchRequest()){
         do {
         controlerArray = try context.fetch(request)
         } catch {
             print(error)
         }
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
            destinationVC.selectedCategory = controlerArray[indexPath.row]
        }
    }
}
