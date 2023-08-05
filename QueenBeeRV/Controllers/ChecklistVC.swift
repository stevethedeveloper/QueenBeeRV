//
//  ChecklistVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/30/23.
//

import UIKit
import CoreData

class ChecklistVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let viewModel = ChecklistViewModel()

    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorColor = .systemGray
        table.register(ChecklistItemCell.self, forCellReuseIdentifier: "cell")
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 44
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Checklist"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setStatusBar(backgroundColor: UIColor(named: "MenuColor")!)

        view.addSubview(tableView)
        viewModel.getAllItems()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive                = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive                            = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive                          = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive                              = true

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

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter new item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.textFields?[0].spellCheckingType = .yes
        alert.textFields?[0].autocorrectionType = .yes
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }

            self?.viewModel.createItem(name: text)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.models.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.models.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChecklistItemCell
        cell.toggleCompletedCallback = {
            self.viewModel.toggleCompleted(item: item)
        }
        
        if !cell.notesHidden {
            cell.toggleNotes()
        }

        cell.reloadCell = {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        cell.set(item: item)
        cell.separatorInset = .zero
        cell.selectionStyle = .none
        if item.completed {
            cell.itemTitleLabel.textColor = .secondaryLabel
            cell.itemTitleLabel.font = UIFont.systemFont(ofSize: 16)
        } else {
            cell.itemTitleLabel.textColor = .label
            cell.itemTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        tableView.cellForRow(at: indexPath)?.imageView?.image = nil
        let item = self.viewModel.models.value[indexPath.row]
        let star = UIContextualAction(style: .normal, title: "Star") { (action, view, handler) in
            self.viewModel.toggleStarred(item: item)
            tableView.reloadData()
        }
        if item.starred {
            let image = UIImage(systemName: "star.fill")
            star.image = image?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        } else {
            let image = UIImage(systemName: "star")
            star.image = image?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        }
        star.backgroundColor = .systemGray5
        
        let configuration = UISwipeActionsConfiguration(actions: [star])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        tableView.deselectRow(at: indexPath, animated: true)
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            let item = self.viewModel.models.value[indexPath.row]
            
            let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes, delete", style: .default, handler: { [weak self] _ in
                self?.viewModel.deleteItem(item: item)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            alert.addAction(UIAlertAction(title: "No, cancel", style: .cancel, handler: { _ in
                tableView.reloadData()
            }))
            self.present(alert, animated: true)
        }
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, handler) in


            let item = self.viewModel.models.value[indexPath.row]

            tableView.deselectRow(at: indexPath, animated: true)

            let vc = ChecklistEditItemVC()
            vc.viewModel.todoListRecord = item
            vc.onViewWillDisappear = {
                tableView.reloadData()
            }
            self.present(vc, animated: true)
        }
        delete.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [delete, edit])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
