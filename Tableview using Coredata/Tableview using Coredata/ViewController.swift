//
//  ViewController.swift
//  Tableview using Coredata
//
//  Created by Tipu on 20/6/23.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
        
        var items: [Item] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.dataSource = self
            tableView.delegate = self
            
            fetchItems()
        }
        
        // MARK: - UITableViewDataSource
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return items.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
            
            let item = items[indexPath.row]
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.itemDescription
            
            return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
        
        // MARK: - Core Data
        
        func fetchItems() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Item>(entityName: "Item")
            
            do {
                items = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        
        func saveItem(title: String, description: String) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext)!
            
            let item = Item(entity: entity, insertInto: managedContext)
            item.title = title
            item.itemDescription = description
            
            do {
                try managedContext.save()
                items.append(item)
                tableView.reloadData()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        // MARK: - Actions
        
        @IBAction func addItem(_ sender: UIBarButtonItem) {
            let alertController = UIAlertController(title: "New Item", message: "Enter the details", preferredStyle: .alert)
            
            alertController.addTextField { textField in
                textField.placeholder = "Title"
            }
            
            alertController.addTextField { textField in
                textField.placeholder = "Description"
            }
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
                guard let titleTextField = alertController.textFields?.first,
                      let descriptionTextField = alertController.textFields?.last,
                      let title = titleTextField.text,
                      let description = descriptionTextField.text
                else {
                    return
                }
                
                saveItem(title: title, description: description)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true)
        }
    }
