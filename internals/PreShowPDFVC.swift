//
//  PreShowPDFVC.swift
//  internals
//
//  Created by ke.liang on 2018/7/7.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import WebKit

class PreShowPDFVC: UIViewController {

    
    
    private lazy var wbView:WKWebView = {
        let wb = WKWebView.init()
        return wb
    }()
    
    internal var fileURL:URL?{
        didSet{
            loadData()
        }
    }
    
    
    private var uploadSucces:Bool = false
    
    
    private lazy var bottomView:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        
        let btn = UIButton()
        btn.setTitle("上传", for: .normal)
        btn.backgroundColor = UIColor.blue
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(upload), for: .touchUpInside)
     
        v.addSubview(btn)
        _ = btn.sd_layout().leftSpaceToView(v,20)?.rightSpaceToView(v,20)?.topSpaceToView(v,10)?.bottomSpaceToView(v,10)
        
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 退出界面删除
        let fileManager = FileManager.default
        do{
            if  fileManager.fileExists(atPath: fileURL!.path){
                try fileManager.removeItem(at: fileURL!)
            }
        }catch{
            print(" delete file error \(error)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}




extension PreShowPDFVC{
    
    private func setView(){
        self.title = "上传附件简历"
        self.view.addSubview(wbView)
        self.view.addSubview(bottomView)
        self.navigationController?.delegate = self
        self.navigationController?.navigationBar.settranslucent(true)

         _ = bottomView.sd_layout().bottomEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.heightIs(60)
        
        _ = wbView.sd_layout().topSpaceToView(self.view,NavH)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomSpaceToView(bottomView,0)
       
        
       
        
    }
    
    private func loadData(){
        if let url = fileURL{
            wbView.loadFileURL(url, allowingReadAccessTo: url)
        }
    }
}


extension PreShowPDFVC: UINavigationControllerDelegate{
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // 刷新数据
        if viewController.isKind(of: ResumePageViewController.self) && uploadSucces{
            (viewController as? ResumePageViewController)?.reload()
        }
    }
}



extension PreShowPDFVC{
    @objc private func upload(){
        
        // 上传到服务器
        // 刷新简历列表
        uploadSucces = true
        self.navigationController?.popvc(animated: true)
        
        
    }
}
