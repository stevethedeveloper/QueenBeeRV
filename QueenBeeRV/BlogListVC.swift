//
//  BlogListVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 5/17/23.
//

import UIKit

class BlogListVC: UIViewController {
    let urlString: String = "https://queenbeerv.com/blog/f.json"
    var blogPosts = [Post]()
    
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Blog"
        configureTableView()
        getPosts()
        tableView.reloadData()
    }
        
    func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        tableView.pin(to: view)
    }
    
    func getPosts() {
        guard let url: URL = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error { print(error) }
            guard let data = data else { return }
            self.parse(json: data)
            return
        }.resume()
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
}

// MARK: Data delegate and datasource functions
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
