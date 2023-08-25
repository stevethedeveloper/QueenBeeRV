//
//  WebviewVC.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 8/25/23.
//

import UIKit
import WebKit

class WebviewVC: UIViewController, WKNavigationDelegate {
    let viewModel = WebviewViewModel()

    private var webView = WKWebView()
    private let doneButton = UIButton()
    private let headerView = UIView()
    private let loadingView = UIView()
    private var loadingImageView = UIImageView()

    override func loadView() {
        let view = UIView()
        self.view = view
        configureDoneButton()
        configureWebView()
        configureAndShowLoadingView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .black
        

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
        headerView.addSubview(doneButton)
        
        doneButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        doneButton.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        doneButton.setTitle("Done", for: .normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            doneButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 50),
            doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)
        ])
    }
    
    private func configureWebView() {
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        webView.backgroundColor = .black
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            webView.topAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
    }

    private func configureAndShowLoadingView() {
        view.addSubview(loadingView)
        
        loadingView.backgroundColor = .black
        loadingView.pin(to: webView)
        
        let image = UIImage(named: "loading")
        loadingImageView.image = image
        loadingImageView.contentMode = .scaleAspectFit
        loadingView.addSubview(loadingImageView)

        loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingImageView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
            loadingImageView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loadingImageView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func loadWebView(forUrlString urlString: String) {
        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let host = navigationAction.request.url?.absoluteURL {
            if host.absoluteURL.absoluteString == viewModel.currentWebsite.value {
                decisionHandler(.allow)
            } else {
                decisionHandler(.cancel)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingView.removeFromSuperview()
    }
}
