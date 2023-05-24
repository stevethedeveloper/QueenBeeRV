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
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self.parse(json: data)
                    return
                }
            }
            
            self.showError()
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonBlogs = try? decoder.decode(Blogs.self, from: json) {
            blogPosts = jsonBlogs.items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func showError() {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
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
        tableView.backgroundColor = .black
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BlogPostVC()
//        vc.modalPresentationStyle = .fullScreen
        vc.currentWebsite = blogPosts[indexPath.row].url
        navigationController?.pushViewController(vc, animated: true)
    }
}
