//
//  BlogListViewModel.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 7/10/23.
//

import Foundation

public class BlogListViewModel {
    let urlString: String = "https://queenbeerv.com/blog/f.json"
    var blogPosts: Observable<[Post]> = Observable([])

//    var blogPosts = [Post]()
    
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
            blogPosts.value = jsonBlogs.items
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
        }
    }

}
