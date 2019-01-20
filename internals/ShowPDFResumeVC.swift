//
//  ShowPDFResumeVC.swift
//  internals
//
//  Created by ke.liang on 2018/7/7.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import PDFKit
import WebKit

fileprivate let navTitle = "附件简历"
class ShowPDFResumeVC: UIViewController {
    
    private lazy var wbView:WKWebView = {
        let wb = WKWebView.init()
        wb.navigationDelegate = self
        return wb
    }()
    
    private lazy var progressView:UIProgressView = {
        let progress = UIProgressView.init(frame: CGRect.zero)
        progress.progressTintColor = UIColor.blue
        progress.trackTintColor = UIColor.clear
        progress.isHidden = true
        return progress
    }()
    

    internal var url:String?{
        didSet{
            self.loadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
       
        
        // Do any additional setup after loading the view.
    }

    
   
    
    
    private func didFinishloadData() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "更多", style: .plain, target: self, action: #selector(more))
        
    }
    
   private func reload() {
        
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

}




extension ShowPDFResumeVC{
    
    private func setView(){
        self.title = navTitle
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(wbView)
        
        self.view.addSubview(progressView)
        _ = progressView.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.view,64)?.heightIs(2)
        
        
        _ = wbView.sd_layout().topSpaceToView(self.view,GlobalConfig.NavH)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
        
        wbView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)

        
    }
    
}


extension ShowPDFResumeVC: WKNavigationDelegate{
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            
            progressView.isHidden = wbView.estimatedProgress == 1
            progressView.setProgress(Float(wbView.estimatedProgress), animated: true)
            
        }
    }
    
    
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
        progressView.setProgress(0, animated: false)
        self.didFinishloadData()
        
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("error ---> \(error)")
        progressView.isHidden = true
        progressView.setProgress(0, animated: false)
    }
    
}

extension ShowPDFResumeVC{
    @objc private func more(){
        
    }
    
    
}


extension ShowPDFResumeVC{
    private func loadData(){
        
        if let target = self.url,  let url  = URL.init(string: target){
            self.wbView.load(URLRequest.init(url: url))
        }
    }
}
