//
//  BlogListVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 5/17/23.
//

import UIKit

class BlogListVC: UIViewController {
    let viewModel = BlogListViewModel()
    var tableView = UITableView()
    
    override func loadView() {
        let view = UIView()
        self.view = view
        configureTableView()
        viewModel.getPosts()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Blog"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.setStatusBar(backgroundColor: UIColor(named: "MenuColor")!)

        viewModel.blogPosts.bind { [weak self] _ in
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
    }
        
    func configureTableView() {
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 130
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
//        tableView.pin(to: view)
        tableView.translatesAutoresizingMaskIntoConstraints                                     = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive    = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive                = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive              = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive                  = true
    }
    
    func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
}

// MARK: Delegate and datasource functions
extension BlogListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.blogPosts.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        cell.separatorInset = .zero
        cell.selectionStyle = .none
        let post = viewModel.blogPosts.value[indexPath.row]
        cell.set(post: post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BlogPostVC()
        vc.viewModel.currentWebsite.value = viewModel.blogPosts.value[indexPath.row].url
        vc.modalPresentationStyle = .pageSheet
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true)
    }
}
