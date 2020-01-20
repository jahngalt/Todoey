 //
//  CategoryViewController.swift
//  Todoey
//
//  Created by Oleg Kudimov on 1/12/20.
//  Copyright © 2020 Oleg Kudimov. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
 
class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    //var categoryArray = [Category]()
    // SetUp context to manipulate with Core Data

    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadCategories()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller doesn't exist")
        }
        
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
    }
    
    
    // MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let ac = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        ac.addTextField  { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if textField.text?.count != 0 {
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.colour = UIColor.randomFlat().hexValue()

                self.save(category: newCategory)
            } else {
                let ac = UIAlertController(title: "Category name can't be empty", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                ac.addAction(action)
                self.present(ac, animated: true, completion: nil)
            }
        }
        ac.addAction(action)
        present(ac, animated: true, completion: nil)
    }
    
    // MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // Turn off selection cell 
        cell.selectionStyle = .none
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString: category.colour) else {fatalError()}
            
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
        } else {
              cell.textLabel?.text = "No Categories added yet"
        }
        
        return cell
    }
    

    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController

        if  let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]

        }
    }

    // MARK: - Data Manipulation Methods
    // Save data to CoreData
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() { 
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    // MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryToDelete = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryToDelete)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
}
 
