//
//  CategoryViewController.swift
//  Todo
//
//  Created by Kyle Thompson on 12/8/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer
        .viewContext;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: - TableView Operations
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CategoryCell",
            for: indexPath)
        
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowItems", sender: self)
    }
    
    // MARK: - User Action Handlers
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(
            title: "Add New Category",
            message: "",
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: "Add Category",
            style: .default) { (action) in
                
                if let
                    text = textField.text,
                    text.trimmingCharacters(in: .whitespaces).count > 0 {
                    
                    let category = Category(context: self.context)
                    category.name = text
                    self.categories.append(category);
                    
                    self.saveCategories()
                    self.tableView.reloadData()
                }
        }
        
        alert.addTextField { (field) in
            textField = field
            field.placeholder = "Create new category"
        }
        
        alert.addAction(action);
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Core Data Operations
    
    /// Saves all changes to the current database context.
    func saveCategories() {
        do {
            try self.context.save()
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    /// Loads all items from current database context,
    /// that matches the specific request query
    func loadCategories(
        with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching Categories: \(error)")
        }
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let destination = segue.destination as? TodoListViewController,
            let indexPath = tableView.indexPathForSelectedRow else {
                
            return
        }
        
        destination.currentCategory = categories[indexPath.row]
    }
}
