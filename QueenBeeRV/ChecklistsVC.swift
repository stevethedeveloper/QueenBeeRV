//
//  ChecklistsVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/30/23.
//

import UIKit
import CoreData

class ChecklistsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    private var models = [TodoList]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "To Do Lists"
        view.addSubview(tableView)
        getAllLists()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New List", message: "Enter new list", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            
            self?.createList(title: text)
        }))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let list = models[indexPath.row]
        let vc = ChecklistVC()
        vc.todoListRecordObjectID = list.objectID
        navigationController?.pushViewController(vc, animated: true)

//
//        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
//        sheet.addAction(UIAlertAction(title: "Go", style: .default, handler: { [weak self] _ in
//            let vc = ViewController()
//            vc.todoListRecordObjectID = list.objectID
//            print(list.todoListItems?.count)
////                    vc.currentWebsite = blogPosts[indexPath.row].url
//            self?.navigationController?.pushViewController(vc, animated: true)
//        }))
//        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] _ in
//            let alert = UIAlertController(title: "Edit List", message: "Edit your list", preferredStyle: .alert)
//            alert.addTextField(configurationHandler: nil)
//            alert.textFields?.first?.text = list.title
//            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
//                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
//                    return
//                }
//
//                self?.updateList(list: list, newName: newName)
//            }))
//            self?.present(alert, animated: true)
//        }))
//        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
//            self?.deleteList(list: list)
//        }))
//        present(sheet, animated: true)

    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        tableView.deselectRow(at: indexPath, animated: true)
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            let item = self.models[indexPath.row]
            
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes, delete", style: .default, handler: { [weak self] _ in
                self?.deleteList(list: item)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            alert.addAction(UIAlertAction(title: "No, cancel", style: .cancel, handler: { _ in
                tableView.reloadData()
            }))
            self.present(alert, animated: true)
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            let item = self.models[indexPath.row]
            
            let alert = UIAlertController(title: "Edit Item", message: "Edit your item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.title
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
                self?.updateList(list: item, newName: newName)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        }

        delete.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [delete, edit])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    

    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = BlogPostVC()
//        vc.currentWebsite = blogPosts[indexPath.row].url
//        navigationController?.pushViewController(vc, animated: true)
//    }


    // Core Data
    func getAllLists() {
        do {
            let fetchRequest: NSFetchRequest<TodoList>
            fetchRequest = TodoList.fetchRequest()
                        
            models = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            
        }
        
        
//        do {
//            models = try context.fetch(TodoList.fetchRequest())
//            print(models)
//
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        } catch {
//
//        }
        
    }
    
    func createList(title: String) {
        let newList = TodoList(context: context)
        newList.title = title
        
        do {
            try context.save()
            getAllLists()
        } catch {
            
        }
    }
    
    func deleteList(list: TodoList) {
        context.delete(list)
        
        do {
            try context.save()
            getAllLists()
        } catch {
            
        }
    }
    
    func updateList(list: TodoList, newName: String) {
        list.title = newName
        
        do {
            try context.save()
            getAllLists()
        } catch {
            
        }
    }

}
