//
//  BlogListVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 5/17/23.
//

import UIKit

class BlogListVC: UIViewController {
    var blogPosts = [Post]()

    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Blog"
        configureTableView()
        
        let urlString: String
        urlString = "https://queenbeerv.com/blog/f.json"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonBlogs = try? decoder.decode(Blogs.self, from: json) {
            blogPosts = jsonBlogs.items
            tableView.reloadData()
        }
    }

    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    func configureTableView() {
        view.addSubview(tableView)
        // set delegates
        tableView.delegate = self
        tableView.dataSource = self
        // set row height
        tableView.rowHeight = 100
        // register cells
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        // set constraints
        tableView.pin(to: view)
    }
}

extension BlogListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = blogPosts[indexPath.row]
        cell.set(post: post)
        return cell
    }
}
