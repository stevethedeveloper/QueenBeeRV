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
}

class HomeVC: UIViewController {
    private var sections = [HomeSection]()

    let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.register(HomeCell.self, forCellReuseIdentifier: "HomeCell")
        table.rowHeight = 200.0
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
                            text: "We've loaded up some super helpful checklists to help keep you organized, safe, and your RV well-maintained. Or you can create your own!",
                            symbol: "checklist"))
        sections.append(HomeSection(
                            title: "Check out our videos!",
                            text: "From New-Bees and Wanna-Bees to seasoned RV pros, there's something for everyone! Check out our entire video library!",
                            symbol: "play.tv.fill"))
        sections.append(HomeSection(
                            title: "Latest Articles!",
                            text: "Tips, advice, food, reviews and more! Check out our buying guides and tips. Kick back and read our latest!",
                            symbol: "doc.text.fill"))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIView()

        tableView.delegate = self
        tableView.dataSource = self



//        navigationController?.navigationBar.prefersLargeTitles = false






//        let viewTop = UIView()
//        viewTop.backgroundColor = .red
//        view.addSubview(viewTop)
//
//        viewTop.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            viewTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            viewTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            viewTop.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -30),
//            viewTop.heightAnchor.constraint(equalToConstant: 200)
//        ])
//







//        let scrollView = UIScrollView()
//        scrollView.backgroundColor = .blue
//        view.addSubview(scrollView)
//        scrollView.pin(to: view)




//        guard let customFont = UIFont(name: "FontdinerdotcomSparkly", size: UIFont.labelFontSize) else {
//            fatalError("""
//                Failed to load the "FontdinerdotcomSparkly" font.
//                Make sure the font file is included in the project and the font name is spelled correctly.
//                """
//            )
//        }

//        for family in UIFont.familyNames.sorted() {
//            let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family) Font names: \(names)")
//        }
//        navigationController?.setStatusBar(backgroundColor: UIColor(named: "MenuColor")!)

//        let tempView = UIView()
//        tempView.backgroundColor = .systemBackground
//        view.addSubview(tempView)







//        let tempLabel = UILabel()
//        tempLabel.font = UIFont.boldSystemFont(ofSize: 40)
//        let tempString = "Get Organized and Stay Safe"
//        let tempAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label, NSAttributedString.Key.font: UIFont(name: "FontdinerdotcomSparkly", size: 30.0)!]
//        let tempAttributedString = NSAttributedString(string: tempString, attributes: tempAttributes)
//        tempLabel.attributedText = tempAttributedString
//        view.addSubview(tempLabel)
//        tempLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            tempLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            tempLabel.heightAnchor.constraint(equalToConstant: 100.0)
//        ])
    }

    func setTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
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
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = sections[indexPath.row].title
//        return cell

        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.set(title: sections[indexPath.row].title, text: sections[indexPath.row].text, symbol: sections[indexPath.row].symbol, row: indexPath.row)
        cell.separatorInset = .zero
        cell.selectionStyle = .none
        return cell
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
}
