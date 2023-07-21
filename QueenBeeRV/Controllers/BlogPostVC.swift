//
//  BlogPostVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 5/22/23.
//

import UIKit
import WebKit

class BlogPostVC: UIViewController, WKNavigationDelegate {
    let viewModel = BlogPostViewModel()

    private var webView: WKWebView!
    private let doneButton = UIButton()
    private let headerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        view.backgroundColor = .black
        
        configureDoneButton()
        configureWebView()
        
        viewModel.currentWebsite.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.loadWebView(forUrlString: self?.viewModel.currentWebsite.value ?? "")
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

    @objc private func dismissModal() {
        self.dismiss(animated: true)
    }
    
    private func configureDoneButton() {
        view.addSubview(headerView)
        headerView.backgroundColor = .black
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 50).isActive = true


        doneButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        headerView.addSubview(doneButton)
        doneButton.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        doneButton.setTitle("Done", for: .normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
    }
    
    private func configureWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        webView.backgroundColor = .black
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
    }
    
    private func loadWebView(forUrlString urlString: String) {
        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
    }
}
