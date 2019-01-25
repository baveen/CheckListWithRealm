//
//  ViewController.swift
//  CheckListWithRealm
//
//  Created by Baveendran Nagendran on 1/25/19.
//  Copyright © 2019 rbsolutions. All rights reserved.
//

import UIKit
import RealmSwift

class CheckListViewController: UITableViewController {
    
    private var toDoItemsArray: Results<CheckListItem>?
    private let realm = try! Realm()
    var parentCategory: CheckListCategory? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItemsArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListItemCell", for: indexPath)
        
        if let item = toDoItemsArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Item Added Yet"
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = toDoItemsArray?[indexPath.row] {
            
            do {
                
                try realm.write {
                    item.done = !item.done
                    tableView.cellForRow(at: indexPath)?.accessoryType = item.done ? .checkmark : .none
                }
            }catch {
                print("Error")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if let item = toDoItemsArray?[indexPath.row] {
            try! realm.write {
                realm.delete(item)
            }
        }
        
        loadItems()
        
    }
    
    @IBAction func addATaskToDo() {
        
        let alertController = UIAlertController(title: "Add a to-do item", message: "", preferredStyle: .alert)
        
        let addItemAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newItem = CheckListItem()
            
            if let textField = alertController.textFields?.first {
                newItem.title = textField.text ?? ""
            }
            newItem.done = false
            if let parentCategory = self.parentCategory {
                
                do {
                    try self.realm.write {
                        parentCategory.items.append(newItem)
                    }
                    
                }catch {
                    print("Error in save new task: \(error)")
                }

            }
            
            self.loadItems()
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter a task title"
        }
        alertController.addAction(addItemAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func loadItems() {
        getData()
        tableView.reloadData()
    }
    
    
    func getData() {
        toDoItemsArray = realm.objects(CheckListItem.self)
    }
    
}

