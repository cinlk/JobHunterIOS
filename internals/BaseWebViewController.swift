//
//  baseWebViewController.swift
//  internals
//
//  Created by ke.liang on 2018/3/20.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

fileprivate let keyStr:String = "estimatedProgress"
fileprivate let imgSize = CGSize.init(width: 25, height: 25)
fileprivate let shareViewH = SingletoneClass.shared.shareViewH

class BaseWebViewController: UIViewController {
    
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
    private lazy var sharedView:ShareView = { [unowned self] in
        let share = ShareView.init(frame: CGRect.init(x: 0, y: GlobalConfig.ScreenH, width: GlobalConfig.ScreenW, height: shareViewH))
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
            if let u = mode{
                loadData(url:u)
            }
           
        }
    }
    // 控制右上角btn 显示
    var showRightBtn:Bool = true
    
    private let dispose = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        addBarItem()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //UIApplication.shared.keyWindow?.addSubview(sharedView)
        self.navigationController?.insertCustomerView(UIColor.orange)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //sharedView.removeFromSuperview()
        self.navigationController?.removeCustomerView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        // 如果key 不存在，崩溃
        //webView.removeObserver(self, forKeyPath: keyStr)
        print("deinit webVC")
        webView.navigationDelegate = nil
    }
    
    
}

extension BaseWebViewController {
    
    private func initView(){
        self.view.addSubview(webView)
        self.view.addSubview(progressView)
        _ = progressView.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.view,64)?.heightIs(2)
        
        webView.frame = self.view.frame        
        webView.rx.observe(String.self, keyStr).subscribe(onNext: { [unowned self]  (newValue) in
            self.progressView.isHidden = self.webView.estimatedProgress == 1
            self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
        }).disposed(by: dispose)
        
    }
    
    private func loadData(url:String){
        if let url = URL.init(string: url){
            let request = URLRequest.init(url: url)
            
            webView.load(request)
        
        }
        
    }
    
    private func addBarItem(){
        self.navigationItem.leftBarButtonItems = [btnBack,btnCancel]
        if showRightBtn{
            self.navigationItem.rightBarButtonItem = shareBtn
        }
    }
    
}

extension BaseWebViewController{
    
    @objc func goBack(){
        if self.webView.canGoBack{
            self.webView.goBack()
        }else{
            //self.navigationController?.popToRootViewController(animated: true)
            self.navigationController?.popvc(animated: true)
         }
    }
    
    @objc func cancel(){
        //self.navigationController?.popToRootViewController(animated: true)

        self.navigationController?.popvc(animated: true)
     }
    @objc func share(){
        self.sharedView.showShare()
       
    }
    
  
    
}

extension BaseWebViewController: WKNavigationDelegate{
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
        progressView.setProgress(0, animated: false)
        //文章标题
        self.navigationItem.title = webView.title
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // -999 之前的请求未完成被取消
        if (error as NSError).code == -999 {
            return
        }
        //print("error ---> \(error)")
        progressView.isHidden = true
        progressView.setProgress(0, animated: false)
    }
    
    
}


extension BaseWebViewController: WKUIDelegate{
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
        //print("error ++++++ \(error)")
        progressView.isHidden = true
        progressView.setProgress(0, animated: false)
        
    }
}

//share 代理
extension BaseWebViewController: shareViewDelegate{
    
    
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
