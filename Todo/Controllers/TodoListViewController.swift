//
//  ViewController.swift
//  Todo
//
//  Created by Kyle Thompson on 12/7/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var items = [TodoItem]()
    var dataFilePath: URL = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)
        .first!.appendingPathComponent("TodoItems.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
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
        saveItems()
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
            self.saveItems()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (field) in
            field.placeholder = "Create new item"
            textField = field
        }
        
        alert.addAction(action);
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.items)
            try data.write(to: self.dataFilePath)
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: self.dataFilePath) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([TodoItem].self, from: data)
            } catch {
                print("Error loading data: \(error)")
            }
        }
    }
}

