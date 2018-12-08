//
//  ViewController.swift
//  Todo
//
//  Created by Kyle Thompson on 12/7/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!

    var items = [Item]()
    var currentCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer
        .viewContext;

    // MARK: - View Setup & Configuration
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        setupTapGesture()
    }
    
    /// Adds a Tap Getsure Recognizer to the view to
    /// intercept actions and dismiss the search keyboard
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.tapGestureRecognized))
        
        tapGesture.cancelsTouchesInView = false;
        
        view.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - TableView Operations
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ItemCell",
            for: indexPath)
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.completed ? .checkmark : .none
        
        return cell;
    }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        
        items[indexPath.row].completed = !items[indexPath.row].completed
        saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - User Action Handlers
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(
            title: "Add New Todo",
            message: "",
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: "Add Item",
            style: .default) { (action) in
            
            if let
                text = textField.text,
                text.trimmingCharacters(in: .whitespaces).count > 0 {
                
                let item = Item(context: self.context)
                item.title = text
                item.category = self.currentCategory
                self.items.append(item);
                
                self.saveItems()
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (field) in
            field.placeholder = "Create new item"
            textField = field
        }
        
        alert.addAction(action);
        present(alert, animated: true, completion: nil)
    }

    @objc func tapGestureRecognized(gesture: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    //MARK: - Core Data Operations
    
    /// Saves all changes to the current database context.
    func saveItems() {
        do {
            try self.context.save()
        } catch {
            print("Error saving data: \(error)")
        }
    }

    /// Loads all items from current database context,
    /// that matches the specific request query
    func loadItems(
        with request: NSFetchRequest<Item> = Item.fetchRequest(),
        predicate: NSPredicate? = nil) {
        
        guard
            let category = currentCategory,
            let categoryName = category.name else {
            return
        }
        
        let categoryPredicate =
            NSPredicate(format: "category.name MATCHES %@", categoryName)
        
        if let predicate = predicate {
            let compoundPredicate = NSCompoundPredicate(
                andPredicateWithSubpredicates: [categoryPredicate, predicate])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            items = try context.fetch(request)
        } catch {
            print("Error fetching Todo items: \(error)")
        }
    }
}

// MARK: - UISearchBarDelegate
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadItems()
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }

    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String) {
        
        guard let text = searchBar.text else {
            return
        }
        
        if text.count == 0 {
            loadItems()
        } else {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            request.sortDescriptors =
                [NSSortDescriptor(key: "title", ascending: true)]
            
            let predicate =
                NSPredicate(format: "title CONTAINS[cd] %@", text)
            
            loadItems(with: request, predicate: predicate)
        }

        tableView.reloadData()
    }
}

