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

    var webView: WKWebView!
//    var progressView: UIProgressView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        self.edgesForExtendedLayout = []
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.isToolbarHidden = false
//    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        viewModel.currentWebsite.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.configureAndLoadWebView(forUrlString: self?.viewModel.currentWebsite.value ?? "")
            }
        }

//        webView = WKWebView()
//        webView.navigationDelegate = self
//        view.addSubview(webView)
////        webView.pin(to: view)
//
//        webView.translatesAutoresizingMaskIntoConstraints                               = false
//        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive             = true
//        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive     = true
//        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive   = true
//        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive       = true
    }

    private func configureAndLoadWebView(forUrlString urlString: String) {
        // TODO - obscures part of page, pin webview to top of this
//        progressView = UIProgressView(progressViewStyle: .default)
//        progressView.sizeToFit()
//        let progressButton = UIBarButtonItem(customView: progressView)
//        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let back = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
//        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
//        let forward = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
//        toolbarItems = [progressButton, spacer, back, forward, refresh]
        navigationController?.isNavigationBarHidden = false
        
//        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.allowsBackForwardNavigationGestures = true
        

        let url = URL(string: urlString)!
        webView.load(URLRequest(url: url))

    }
    
    
//    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.isToolbarHidden = true
//    }

//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "estimatedProgress" {
//            progressView.progress = Float(webView.estimatedProgress)
//        }
//    }
    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        title = webView.title
//    }
}
