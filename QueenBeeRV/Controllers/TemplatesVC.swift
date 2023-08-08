//
//  TemplatesVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 8/3/23.
//

import UIKit

class TemplatesVC: UIViewController {
    private let viewModel = TemplatesViewModel()
    private let cancelButton = UIButton()
    private let headerView = UIView()
    private let titleLabel = UILabel()

    var onViewWillDisappear: ((Template)->())?
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorColor = .systemGray
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 44
        return table
    }()
    
    override func loadView() {
        let view = UIView()
        self.view = view
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        viewModel.loadTemplatesFromFile()
        configureCancelButton()
        configureTitleLabel()
        setTableViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.templates.bind { [weak self] _ in
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
        
    private func configureCancelButton() {
        view.addSubview(headerView)
        headerView.backgroundColor = .systemBackground
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(cancelButton)
        
        cancelButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        cancelButton.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 60),
            cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)
        ])
    }
    
    private func configureTitleLabel() {
        titleLabel.text = "Select a Template"
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.textColor = UIColor(named: "AccentColor")
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10)
        ])
    }
    
    private func setTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    @objc private func dismissModal() {
        self.dismiss(animated: true)
    }
}

extension TemplatesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.templates.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = viewModel.templates.value[indexPath.row].title
        cell.detailTextLabel?.text = viewModel.templates.value[indexPath.row].description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onViewWillDisappear?(viewModel.templates.value[indexPath.row])
        dismissModal()
    }
}
