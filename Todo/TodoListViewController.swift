//
//  ViewController.swift
//  Todo
//
//  Created by Kyle Thompson on 12/7/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var items = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedItems = defaults.array(forKey: "TodoListItems") as? [String] {
            self.items = savedItems
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView
            .dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark)
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todo",
                                      message: "",
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.items.append(textField.text!)
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

