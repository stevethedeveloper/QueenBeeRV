//
//  BlogListVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 5/17/23.
//

import UIKit

class BlogListVC: UIViewController, CachableJSON {
    
    var cacheJSONFileName: String = "BlogListVC"
    var cacheJSONHours: Int = 1
    
    let urlString: String = "https://queenbeerv.com/blog/f.json"
    var blogPosts = [Post]()
    
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Blog"
        configureTableView()
        
        
        
        //        let url = URL(string: urlString)!
        
        //        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //        let configuration = URLSessionConfiguration.default
        //        configuration.requestCachePolicy = .returnCacheDataElseLoad
        ////        URLCache.shared.removeAllCachedResponses()
        //        let urlSession = URLSession(configuration: configuration)
        //
        //        let task = urlSession.dataTask(with: url) { data, response, error in
        //            if let data = data {
        //                self.parse(json: data)
        //            } else {
        //                print("Invalid response")
        //            }
        //        }
        //
        //        task.resume()
        //
        
        getPosts()
        tableView.reloadData()
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        tableView.pin(to: view)
//        tableView.backgroundColor = .black
    }
    
    func getPosts(_ forceLoad: Bool = false) {
        let cache = CacheJSON(cacheFile: cacheJSONFileName, cacheHours: cacheJSONHours)
        if let jsonString = cache.getJSONString() {
            DispatchQueue.global(qos: .userInitiated).async {
                let data = Data(jsonString.utf8)
                self.parse(json: data)
                print("cache")
            }
        } else {
            loadBlogList()
            print("load")
        }
        
        
//        let defaults = UserDefaults.standard
////                defaults.set(nil, forKey: "lastBlogListLoadTime")
//        let currentTime = NSDate() as Date
//        if let lastBlogPostLoad = defaults.object(forKey: "lastBlogListLoadTime") as? Date {
//            if currentTime > lastBlogPostLoad.addingTimeInterval(1 * 60 * 60) {
//                print("load 1 \(lastBlogPostLoad.addingTimeInterval(1 * 60 * 60))")
//                loadBlogList()
//            } else {
//                print("cache")
//                loadBlogList(fromCache: true)
////                return
//            }
//        } else {
//            print("load 2")
//            loadBlogList()
//        }
        
        
        //        let jsonEncoder = JSONEncoder()
        //        if let savedData = try? jsonEncoder.encode(blogPosts) {
        //            let defaults = UserDefaults.standard
        //            defaults.set(savedData, forKey: "blogPosts")
        //        } else {
        //            print("Failed to save people.")
        //        }
    }
    
    func loadBlogList() {
        let cache = CacheJSON(cacheFile: cacheJSONFileName, cacheHours: cacheJSONHours)

        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: self.urlString) {
                if let data = try? Data(contentsOf: url) {
                    self.parse(json: data)
                    cache.cacheJSON(String(decoding: data, as: UTF8.self))
                    return
                }
            }
            
            self.showError()
        }
        
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
