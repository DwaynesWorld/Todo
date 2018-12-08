//
//  ViewController.swift
//  Todo
//
//  Created by Kyle Thompson on 12/7/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    var items = [TodoItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedItems = defaults.array(forKey: "TodoListItems") as? [TodoItem] {
            self.items = savedItems
        } else {            
            self.items.append(TodoItem("Find Mike"))
            self.items.append(TodoItem("Buy Eggos"))
            self.items.append(TodoItem("Destroy Demogorgon"))
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.completed ? .checkmark : .none
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        items[indexPath.row].completed = !items[indexPath.row].completed
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todo",
                                      message: "",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.items.append(TodoItem(textField.text!))
            self.defaults.set(self.items, forKey: "TodoListItems")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (field) in
            field.placeholder = "Create new item"
            textField = field
        }
        
        alert.addAction(action);
        present(alert, animated: true, completion: nil)
    }
}

