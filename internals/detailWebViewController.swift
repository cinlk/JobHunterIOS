//
//  detailWebViewController.swift
//  internals
//
//  Created by ke.liang on 2018/1/11.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class detailWebViewController: UIViewController {
    
    lazy var webNews:WebNewsView = {
        let wn = WebNewsView.init(frame: CGRect.zero)
        return wn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.loadData()
        
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "文章标题"
        
    }
    
    private func setViews(){
        
        self.webNews.delegate = self
        self.webNews.scrollView.delegate = self
        self.view.addSubview(webNews)
        _ = self.webNews.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
    }
    
    private func loadData(){
       // self.webNews.loadHTMLString(<#T##string: String##String#>, baseURL: <#T##URL?#>)
        let url = URLRequest.init(url: URL.init(string: "https://www.baidu.com")! )
        self.webNews.loadRequest(url)
    }

}


extension detailWebViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         
        
    }
}

extension detailWebViewController:UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webNews.waitView.removeFromSuperview()
    }
}
