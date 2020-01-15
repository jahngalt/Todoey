 //
//  CategoryViewController.swift
//  Todoey
//
//  Created by Oleg Kudimov on 1/12/20.
//  Copyright © 2020 Oleg Kudimov. All rights reserved.
//

import UIKit
import CoreData
 
class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    // SetUp context to manipulate with Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

       
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
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text!
                self.categoryArray.append(newCategory)
                self.saveCategories()
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
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row
        //tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if  let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
    }
    
    // Swipe to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             context.delete(categoryArray[indexPath.row])
             categoryArray.remove(at: indexPath.row)
             tableView.deleteRows(at: [indexPath], with: .fade)
             
             saveCategories()
         }
     }
    
    // MARK: - Data Manipulation Methods
    // Save data to CoreData
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
    // Load data from CoreData
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("error fetching data from context, \(error)")
        }
    }
}
