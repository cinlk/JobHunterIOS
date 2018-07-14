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
    
    
    // 自适应屏幕
   
    private lazy var wkContent:WKUserContentController = {
        let content = WKUserContentController()
        let jsString = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let script = WKUserScript.init(source: jsString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        content.addUserScript(script)
        return content
    }()
    private lazy var webConfig:WKWebViewConfiguration =  { [unowned self] in
        let config = WKWebViewConfiguration()
        config.userContentController = self.wkContent
        return config
    }()
    
    private lazy var webView: WKWebView = { [unowned self] in
        //let web = WKWebView.init(frame: CGRect.zero, configuration: self.webConfig)
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
        share.delegate = self
        return share
    }()
    
    
    private lazy var btnBack:UIBarButtonItem = { [unowned self] in
        
        let img = UIImage.init(named: "back")?.changesize(size: imgSize).withRenderingMode(.alwaysTemplate)
        
        let b1 = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        b1.tintColor = UIColor.lightGray
        b1.setImage(img, for: .normal)
        b1.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return UIBarButtonItem.init(customView: b1)
        
        
    }()
    
    
    
    private lazy var btnCancel:UIBarButtonItem = { [unowned self] in
        
        let img = UIImage.init(named: "cancel")?.changesize(size: imgSize).withRenderingMode(.alwaysTemplate)

        let b1 = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        b1.setImage(img, for: .normal)
        b1.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        b1.tintColor = UIColor.lightGray

        return UIBarButtonItem.init(customView: b1)
        
    }()
    
    private lazy var shareBtn:UIBarButtonItem = { [unowned self] in
        
        let img = UIImage.init(named: "upload")?.changesize(size: imgSize).withRenderingMode(.alwaysTemplate)
        let b1 = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        b1.tintColor = UIColor.lightGray

        b1.addTarget(self, action: #selector(share), for: .touchUpInside)
        b1.clipsToBounds = true
        b1.setImage(img, for: .normal)
        
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
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.keyWindow?.addSubview(sharedView)

        self.navigationController?.insertCustomerView(UIColor.blue)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sharedView.removeFromSuperview()
        self.navigationController?.removeCustomerView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        // 如果key 不存在，崩溃
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
        self.navigationItem.leftBarButtonItems = [btnBack,btnCancel]
        self.navigationItem.rightBarButtonItem = shareBtn
    }
    
}

extension baseWebViewController{
    
    @objc func goBack(){
        if self.webView.canGoBack{
            self.webView.goBack()
        }else{
            self.navigationController?.popvc(animated: true)
         }
    }
    
    @objc func cancel(){
        self.navigationController?.popvc(animated: true)
     }
    @objc func share(){
        self.sharedView.showShare()
       
    }
    
  
    
}

extension baseWebViewController: WKNavigationDelegate{
    
    // 获取进度值 设置progress
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == keyStr{
            
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
           
        }
    }
    
    
    
    
   
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
        progressView.setProgress(0, animated: false)
        //文章标题
        self.navigationItem.title = webView.title
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("error ---> \(error)")
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
    
    // 内容加载 错误
    func  webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("error ---> \(error)")
        progressView.isHidden = true
        progressView.setProgress(0, animated: false)
        
    }
}

//share 代理
extension baseWebViewController: shareViewDelegate{
    
    
    func handleShareType(type: UMSocialPlatformType, view: UIView) {
        
        switch type {
        case .copyLink:
            self.copyToPasteBoard(text: "这是文本内容")
            
        case .more:
            // 文本
            self.openMore(text: "打开的内容", site: URL.init(string: "http://www.baidu.com"))
            
            
            
        case .wechatTimeLine, .wechatSession, .QQ, .qzone, .sina:
            self.shareToApp(type: type, view: view, title: "分享标题", des: "分享描述", url: "http://www.hangge.com/blog/cache/detail_641.html", image: UIImage.init(named: "chrome"))
            
            
        default:
            break
            
        }
        // 影藏shareview
        sharedView.dismiss()
        
    }
    
    
    
}
