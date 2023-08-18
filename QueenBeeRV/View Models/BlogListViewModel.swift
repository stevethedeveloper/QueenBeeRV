//
//  BlogListViewModel.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 7/10/23.
//

import Foundation

public class BlogListViewModel {
    var onErrorHandling: ((String) -> Void)?
    let urlString: String = "https://queenbeerv.com/blog/f.json"
    var blogPosts: Observable<[Post]> = Observable([])

    // An example of using URLSession with completion handler instead of async/await
    // The function's completion handler is for unit tests
    func getPosts(completion: @escaping (Bool) -> Void = {_ in }) {
        guard let url: URL = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.cachePolicy = .useProtocolCachePolicy
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                self.onErrorHandling?("Could not retrieve articles.  Please check your connection and try again.")
                completion(false)
            }
            guard let data = data else { return }
            self.parse(json: data)
            completion(true)
            return
        }.resume()
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonBlogs = try? decoder.decode(Blogs.self, from: json) {
            blogPosts.value = jsonBlogs.items
        }
    }

}
