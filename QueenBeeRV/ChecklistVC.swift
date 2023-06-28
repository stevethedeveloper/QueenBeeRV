//
//  Checklist.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 6/27/23.
//

import UIKit


class ChecklistVC: UIViewController {
    var checklist: Checklist?
    
//    var incompleteItems = [Post]()
    
    var tableView = UITableView()
    
    override func loadView() {
        let view = UIView()
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Checklist"
        
        configureTableView()
        getChecklist()
        tableView.reloadData()
    }
        
    func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ItemCell")
        //        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        tableView.pin(to: view)
    }
    
    func getChecklist() {
        var titleString = ""
        var completedValue = false
        
            if let checklistFileURL = Bundle.main.url(forResource: "checklist_in", withExtension: "json") {
                var request = URLRequest(url: checklistFileURL)
                request.cachePolicy = .reloadIgnoringCacheData
                
                URLSession.shared.dataTask(with: checklistFileURL) { data, response, error in
                    if let error = error { print(error) }
                    guard let data = data else { return }
//                    print("a: \((String(data: data, encoding: String.Encoding.utf8) ?? "nothing") as String)")
                    self.parse(json: data)
//                    print(self.allItems)
                    return
                }.resume()

//                if let checklistContents = try? String(contentsOf: checklistFileURL) {
//                    print(checklistContents)
//                }
            }
//        guard let url: URL = URL(string: urlString) else { return }
//
//        var request = URLRequest(url: url)
//        request.cachePolicy = .useProtocolCachePolicy
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error { print(error) }
//            guard let data = data else { return }
//            self.parse(json: data)
//            return
//        }.resume()
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonChecklist = try? decoder.decode(Checklist.self, from: json) {
            checklist = jsonChecklist
            print(checklist)
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
extension ChecklistVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let item = checklist?.items[indexPath.row]
        cell.textLabel?.text = item?.title
//        cell.set(post: post)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = BlogPostVC()
////        vc.modalPresentationStyle = .fullScreen
//        vc.currentWebsite = blogPosts[indexPath.row].url
//        navigationController?.pushViewController(vc, animated: true)
//    }
}
