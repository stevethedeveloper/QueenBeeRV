//
//  BlogListVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 5/17/23.
//

import UIKit

class BlogListVC: UIViewController {
    private let viewModel = BlogListViewModel()
    private var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.rowHeight = 130
        table.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        return table
    }()
    
    override func loadView() {
        let view = UIView()
        self.view = view
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setTableViewConstraints()
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
        
    private func setTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
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
