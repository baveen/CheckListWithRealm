//
//  CategoryTableViewController.swift
//  CheckListWithRealm
//
//  Created by Baveendran Nagendran on 1/25/19.
//  Copyright © 2019 rbsolutions. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    private let realm = try! Realm()
    private var categoryArray: Results<CheckListCategory>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (categoryArray?.count == 0) ? 1 : categoryArray!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListCategoryCell", for: indexPath)
        
        if categoryArray!.count > 0, let item =  categoryArray?[indexPath.row] {
             cell.textLabel?.text = item.name
        }else{
            cell.textLabel?.text = "No List Created Yet"
        }
        return cell

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categoryArray!.count > 0 {
            performSegue(withIdentifier: "CheckListsSegue", sender: self)
        }else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let item = categoryArray?[indexPath.row] else {
            return
        }
        do {
            try realm.write {
                realm.delete(item)
            }
        }catch {
            print("Error in deleting")
        }
        
        loadCategories()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! CheckListViewController
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow, let selectedCategory = categoryArray?[selectedIndexPath.row] {
            destinationVc.parentCategory = selectedCategory
        }
        
    }

    @IBAction func addANewCategory() {
        
        let alertController = UIAlertController(title: "Crate a New Category List", message: "", preferredStyle: .alert)
        
        let addItemAction = UIAlertAction(title: "Create", style: .default) { (action) in
            
            let newItem = CheckListCategory()
            
            if let textField = alertController.textFields?.first {
                newItem.name = textField.text ?? ""
            }
            
            do {
                try self.realm.write {
                    self.realm.add(newItem)
                }
            }catch {
                print("Error in create cateogry: \(error)")
            }
            
            self.loadCategories()
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter new category title"
        }
        
        alertController.addAction(addItemAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func loadCategories() {
        getData()
        tableView.reloadData()
    }
    
    func getData() {
        categoryArray = realm.objects(CheckListCategory.self)
    }

}
