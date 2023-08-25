//
//  HomeVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 7/28/23.
//

import UIKit

struct HomeSection {
    var title: String
    var text: String
    var symbol: String
    var tabIndex: Int
}

class HomeVC: UIViewController {
    private var sections = [HomeSection]()

    let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.register(HomeCell.self, forCellReuseIdentifier: "HomeCell")
        table.rowHeight = 200.0
        table.tableFooterView = nil
        return table
    }()

    override func loadView() {
        let view = UIView()
        self.view = view
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        setTableViewConstraints()
        sections.append(HomeSection(
                            title: "Get Organized and Stay Safe!",
                            text: "We've loaded up some super helpful checklists to help keep you organized, safe, and your RV well-maintained.",
                            symbol: "checklist",
                            tabIndex: 1
        ))
        sections.append(HomeSection(
                            title: "Check out our videos!",
                            text: "From New-Bees and Wanna-Bees to seasoned RV pros, there's something for everyone!",
                            symbol: "play.tv.fill",
                            tabIndex: 2
        ))
        sections.append(HomeSection(
                            title: "Latest Articles!",
                            text: "Tips, advice, food, reviews and more! Check out our buying guides and tips. Kick back and read our latest!",
                            symbol: "doc.text.fill",
                            tabIndex: 3
        ))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIView()

        tableView.delegate = self
        tableView.dataSource = self
    }

    func setTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0)
        ])
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.set(title: sections[indexPath.row].title, text: sections[indexPath.row].text, symbol: sections[indexPath.row].symbol, row: indexPath.row)
        cell.separatorInset = .zero
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        footerView.backgroundColor = .systemBackground
        
        let button_tos = UIButton(type: .custom, primaryAction: UIAction(title: "Terms of Service", handler: { _ in
            let vc = WebviewVC()
            vc.viewModel.currentWebsite.value = "https://queenbeerv.com/terms-of-use"
            self.present(vc, animated: true)
        }))
        button_tos.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        button_tos.center = footerView.center
        button_tos.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        button_tos.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button_tos.backgroundColor = .systemBackground

        let button_privacy = UIButton(type: .custom, primaryAction: UIAction(title: "Privacy Policy", handler: { _ in
            let vc = WebviewVC()
            vc.viewModel.currentWebsite.value = "https://queenbeerv.com/privacy-policy"
            self.present(vc, animated: true)
        }))
        button_privacy.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        button_privacy.center = footerView.center
        button_privacy.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        button_privacy.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button_privacy.backgroundColor = .systemBackground

        footerView.addSubview(button_tos)
        footerView.addSubview(button_privacy)
        
        button_tos.translatesAutoresizingMaskIntoConstraints = false
        button_privacy.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button_tos.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            button_privacy.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            button_tos.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 40.0),
            button_privacy.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 40.0)
        ])
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = VideoVC()
        self.tabBarController?.selectedIndex = sections[indexPath.row].tabIndex
    }
}
