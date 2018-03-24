//
//  baseWebViewController.swift
//  internals
//
//  Created by ke.liang on 2018/3/20.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import WebKit

fileprivate let keyStr:String = "estimatedProgress"
fileprivate let imgSize = CGSize.init(width: 25, height: 25)


class baseWebViewController: UIViewController {
    
    
    private lazy var webView: WKWebView = { [unowned self] in
        let web = WKWebView.init(frame: CGRect.zero)
        web.navigationDelegate = self
        web.uiDelegate = self
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
    
    
    //share
    private lazy var sharedView:shareView = {
        let share = shareView.init(frame: CGRect.init(x: 0, y: ScreenH, width: ScreenW, height: shareViewH))
        UIApplication.shared.windows.last?.insertSubview(share, at: 1)
        return share
    }()
    
    private lazy var shareOriginY:CGFloat = 0
    
    private lazy var backGroudView:UIView = { [unowned self] in
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH))
        v.backgroundColor = UIColor.init(r: 127, g: 127, b: 127, alpha: 0.5)
        let tap = UITapGestureRecognizer.init()
        tap.numberOfTapsRequired  = 1
        tap.addTarget(self, action: #selector(clooseShareView(tap:)))
        v.addGestureRecognizer(tap)
        return v
    }()
    
    private lazy var btnBack:UIBarButtonItem = { [unowned self] in
        
        let back = UIImage.barImage(size: imgSize, offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "back")
        let b1 = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        b1.setImage(back, for: .normal)
        b1.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return UIBarButtonItem.init(customView: b1)
        
        
    }()
    
    
    private lazy var btnForward:UIBarButtonItem = { [unowned self] in
       
        let back = UIImage.barImage(size: imgSize, offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "back")
       
        let b1 = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        b1.setImage( UIImage.flipImage(image: back, orientation: .upMirrored), for: .normal)
        b1.addTarget(self, action: #selector(goForward), for: .touchUpInside)
        return UIBarButtonItem.init(customView: b1)
    }()
    
    private lazy var btnCancel:UIBarButtonItem = { [unowned self] in
        
        let back = UIImage.barImage(size: imgSize, offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "cancel")
        let b1 = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        b1.setImage(back, for: .normal)
        b1.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        return UIBarButtonItem.init(customView: b1)
        
    }()
    
    private lazy var shareBtn:UIBarButtonItem = { [unowned self] in
        
        let shares = UIImage.barImage(size: imgSize, offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "upload")
        let b1 = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        b1.addTarget(self, action: #selector(share), for: .touchUpInside)
        b1.clipsToBounds = true
        b1.setImage(shares, for: .normal)
        
         return UIBarButtonItem.init(customView: b1)
    }()
    
    var mode:String?{
        didSet{
            
            loadData(url:mode!)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        addBarItem()
        shareOriginY = sharedView.origin.y
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.insertCustomerView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.removeCustomerView()
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

extension baseWebViewController {
    
    private func initView(){
        self.view.addSubview(webView)
        self.view.addSubview(progressView)
        
        
        _ = progressView.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.view,64)?.heightIs(2)
        
        webView.frame = self.view.frame
        webView.addObserver(self, forKeyPath: keyStr, options: .new, context: nil)
        
    }
    private func loadData(url:String){
        if let url = URL.init(string: url){
            let request = URLRequest.init(url: url)
            webView.load(request)
        }
        
    }
    
    private func addBarItem(){
        self.navigationItem.leftBarButtonItems = [btnBack,btnForward,btnCancel]
        self.navigationItem.rightBarButtonItem = shareBtn
    }
    
}

extension baseWebViewController{
    
    @objc func goBack(){
        if self.webView.canGoBack{
            self.webView.goBack()
        }
    }
    
    @objc func goForward(){
        if self.webView.canGoForward{
            self.webView.goForward()
        }
    }
    @objc func cancel(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func share(){
        self.navigationController?.view.addSubview(backGroudView)
        UIView.animate(withDuration: 0.5, animations: {
            self.sharedView.origin.y = ScreenH  - shareViewH
            
        }, completion: nil)
        print("share data")
    }
    
    @objc func clooseShareView(tap:UIGestureRecognizer){
        if tap.state == .ended{
            backGroudView.removeFromSuperview()
            self.navigationController?.view.willRemoveSubview(backGroudView)
            UIView.animate(withDuration: 0.5, animations: {
                self.sharedView.origin.y = ScreenH
            }, completion: nil)
        }
    }
}

extension baseWebViewController: WKNavigationDelegate{
    
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
        //文章标题
        self.navigationItem.title = webView.title
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
        progressView.setProgress(0, animated: false)
    }
    
    
}


extension baseWebViewController: WKUIDelegate{
    // 允许http连接 跳转
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame?.isMainFrame != nil {
            self.webView.load(navigationAction.request)
        }
        return nil
    }
    
    // 识别javascript 返回数据
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "test", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
