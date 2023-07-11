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
        let table = UITableView()
        table.separatorColor = .systemGray
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "To Do List"
        view.addSubview(tableView)
        viewModel.getAllItems()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.bounds
        
        viewModel.models.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter new item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.textFields?[0].spellCheckingType = .yes
        alert.textFields?[0].autocorrectionType = .yes
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            
            self?.viewModel.createItem(name: text)
        }))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.models.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.models.value[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = item.name
        cell.separatorInset = .zero
        
        var buttonConfiguration = UIButton.Configuration.bordered()

        if item.starred {
            let image = UIImage(systemName: "star.fill")
            cell.imageView?.image = image?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        } else {
            cell.imageView?.image = nil
        }

        if item.completed {
            cell.textLabel?.textColor = .secondaryLabel
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            buttonConfiguration.image = UIImage(systemName: "checkmark")
        } else {
            cell.textLabel?.textColor = .label
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            buttonConfiguration.image = UIImage()
        }
        
        buttonConfiguration.title = ""
        buttonConfiguration.imagePadding = 0
        buttonConfiguration.background.backgroundColor = .systemBackground
        
        //        let button = UIButton(configuration: buttonConfiguration, primaryAction: UIAction(title: "View All Videos", handler: { _ in
        //
        ////        let button = UIButton(type: .custom, primaryAction: UIAction(title: "View All Videos", handler: { _ in
        ////            let vc = PlaylistVC()
        ////            vc.playlistID = self.youtubeAllVideosPlaylistID
        ////            vc.playlistName = "All Videos"
        ////            vc.selectedVideo = self.latestVideos?.items[0]
        ////            self.navigationController?.pushViewController(vc, animated: true)
        //            print(indexPath)
        //        }))
        
        let button = UIButton(configuration: buttonConfiguration)
        
        button.addAction(UIAction(title: "", handler: { _ in
            self.viewModel.toggleCompleted(item: item)
            //        let button = UIButton(type: .custom, primaryAction: UIAction(title: "View All Videos", handler: { _ in
            //            let vc = PlaylistVC()
            //            vc.playlistID = self.youtubeAllVideosPlaylistID
            //            vc.playlistName = "All Videos"
            //            vc.selectedVideo = self.latestVideos?.items[0]
            //            self.navigationController?.pushViewController(vc, animated: true)
            print(indexPath)
        }), for: .touchUpInside)
        
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setTitle("", for: .normal)
        //        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 10.0
        //        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.imageView?.tintColor = .systemGreen
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.borderWidth = 1.0
        
        cell.accessoryView = button
        
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        tableView.cellForRow(at: indexPath)?.imageView?.image = nil
        let item = self.viewModel.models.value[indexPath.row]
        let star = UIContextualAction(style: .normal, title: "Star") { (action, view, handler) in
            item.starred = !item.starred
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
            
            let alert = UIAlertController(title: "Edit Item", message: "Edit your item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
                
                self?.viewModel.updateItem(item: item, newName: newName)
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
