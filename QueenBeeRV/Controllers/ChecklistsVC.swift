//
//  ChecklistsVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/30/23.
//

import UIKit
import CoreData

class ChecklistsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let viewModel = ChecklistsViewModel()

    let tableView: UITableView = {
        let table = UITableView()
        table.separatorColor = .systemGray
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.models.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        viewModel.onErrorHandling = { error in
            DispatchQueue.main.async {
                let ac = UIAlertController(title: "An error occured", message: error, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            }
        }

        title = "Checkists"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setStatusBar(backgroundColor: UIColor(named: "MenuColor")!)
        
        view.addSubview(tableView)
        viewModel.getAllLists()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints                                                 = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive  = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive                            = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive                          = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive                              = true

        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New List", message: "Enter new list", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.textFields?[0].spellCheckingType = .yes
        alert.textFields?[0].autocorrectionType = .yes
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            
            self?.viewModel.createList(title: text)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.models.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.models.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.separatorInset = .zero
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let list = viewModel.models.value[indexPath.row]
        let vc = ChecklistVC()
        vc.viewModel.todoListRecordObjectID = list.objectID
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        tableView.deselectRow(at: indexPath, animated: true)
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            let item = self.viewModel.models.value[indexPath.row]
            
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes, delete", style: .default, handler: { [weak self] _ in
                self?.viewModel.deleteList(list: item)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            alert.addAction(UIAlertAction(title: "No, cancel", style: .cancel, handler: { _ in
                tableView.reloadData()
            }))
            self.present(alert, animated: true)
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in
            let item = self.viewModel.models.value[indexPath.row]
            
            let alert = UIAlertController(title: "Edit Item", message: "Edit your item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.title
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
                self?.viewModel.updateList(list: item, newName: newName)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        }

        delete.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [delete, edit])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
