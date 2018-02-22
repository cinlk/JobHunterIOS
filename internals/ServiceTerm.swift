//
//  ServiceTerm.swift
//  internals
//
//  Created by ke.liang on 2018/2/20.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import WebKit

fileprivate let urlStr:String = "https://codeday.me/bug/20171028/90322.html"
fileprivate let keyStr:String = "estimatedProgress"
class ServiceTerm: UIViewController {

    
    private lazy var webView: WKWebView = {
        let web = WKWebView.init(frame: CGRect.zero)
        web.navigationDelegate = self
        return web
    }()
    
    //
    private lazy var progressView:UIProgressView = {
        let progress = UIProgressView.init(frame: CGRect.zero)
        progress.progressTintColor = UIColor.blue
        progress.trackTintColor = UIColor.clear
        progress.isHidden = true
        return progress
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        loadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "服务条款"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: keyStr)
        webView.navigationDelegate = nil
    }
    

}

extension ServiceTerm {
    
    private func initView(){
        self.view.addSubview(webView)
        self.view.addSubview(progressView)
        _ = progressView.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.view,64)?.heightIs(2)
        
        webView.frame = self.view.frame
        webView.addObserver(self, forKeyPath: keyStr, options: .new, context: nil)
        
    }
    private func loadData(){
        if let url = URL.init(string: urlStr){
            let request = URLRequest.init(url: url)
            webView.load(request)
        }
       
    }
    
}

extension ServiceTerm: WKNavigationDelegate{
    
    // 获取进度值 设置progress
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == keyStr{
            let newp = change?[NSKeyValueChangeKey.newKey] as! Float
            let oldp = change?[NSKeyValueChangeKey.oldKey] as? Float ?? 0.0
            if newp < oldp{
                return
            }
            if newp == 1{
                progressView.isHidden = true
                progressView.setProgress(0, animated: false)
            }else{
                progressView.isHidden = false
                progressView.setProgress(Float(newp), animated: true)
            }
            
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
        progressView.setProgress(0, animated: false)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
        progressView.setProgress(0, animated: false)
    }
}
