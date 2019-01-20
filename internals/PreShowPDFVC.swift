//
//  PreShowPDFVC.swift
//  internals
//
//  Created by ke.liang on 2018/7/7.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import WebKit
import RxSwift




fileprivate class BottomView:UIView{

    
    //fileprivate var delegate:
    
   public lazy var btn:UIButton = {
        let btn = UIButton.init(type:  UIButton.ButtonType.custom)
        //btn.addTarget(self, action: #selector(self.touch(sender:)), for: .touchUpInside)
       
        btn.setTitle("上传", for: .normal)
        btn.backgroundColor = UIColor.blue
        btn.setTitleColor(UIColor.white, for: .normal)
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.btn)
        self.backgroundColor = UIColor.white
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.addSubview(self.btn)
        _ = btn.sd_layout().leftSpaceToView(self,20)?.rightSpaceToView(self,20)?.topSpaceToView(self,10)?.bottomSpaceToView(self,10)
    }
    
    
}






class PreShowPDFVC: UIViewController {

    
    
    
    private lazy var dispose:DisposeBag = {
        return DisposeBag.init()
    }()
    private var vm:PreShowPDFVCViewModel = {
        return PreShowPDFVCViewModel.init()
    }()
    
    
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
    
    
//    private lazy var bottomView:UIView = {
//        let v = UIView()
//        v.backgroundColor = UIColor.white
//        let btn = UIButton()
//        btn.setTitle("上传", for: .normal)
//        btn.backgroundColor = UIColor.blue
//        btn.setTitleColor(UIColor.white, for: .normal)
//        btn.addTarget(self, action: #selector(upload), for: .touchUpInside)
//
//        v.addSubview(btn)
//        _ = btn.sd_layout().leftSpaceToView(v,20)?.rightSpaceToView(v,20)?.topSpaceToView(v,10)?.bottomSpaceToView(v,10)
//
//        return v
//    }()
    
    private lazy var bottomView:BottomView = {
        return BottomView()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        viewModel()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 退出界面删除
        
        do{
            if  SingletoneClass.fileManager.fileExists(atPath: fileURL!.path){
                try SingletoneClass.fileManager.removeItem(at: fileURL!)
            }
        }catch{
            print(" delete file error \(error)")
            // TODO  app 每次退出时也删除 和 清空缓存时删除（保证删除）
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
        
        _ = wbView.sd_layout().topSpaceToView(self.view,GlobalConfig.NavH)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomSpaceToView(bottomView,0)
       
        
       
        
    }
    
    private func loadData(){
        if let url = fileURL{
            wbView.loadFileURL(url, allowingReadAccessTo: url)
            // 传递数据
            vm.fileURL = url
            print("test")
            
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
    
    
    
    private func viewModel(){
        // 监听btn 点击事件 (显示加载 进度， btn 状态无法点击)
        //self.bottomView.btn.addTarget(self, action: #selector(click), for: .touchUpInside)
        
        
        //self.bottomView.btn.rx.tap.bind(to: vm.btnTab).disposed(by: self.dispose)
        self.bottomView.btn.rx.tap.asDriver().drive(onNext: { v in
            print("tap")
           
            self.view.showLoading(title: "加载中", customImage: nil, mode: .customView)
            self.bottomView.btn.isEnabled = false
            self.vm.btnTab.onNext(v)


        }).disposed(by: self.dispose)
        
     
        
        self.vm.uploadResult.asDriver(onErrorJustReturn: false).drive(onNext: { b in
            // 不管上传成功后返回
            // hidden toast TODO
            print("end upload")
            
            self.bottomView.btn.isEnabled = true
            self.uploadSucces = b
            if self.uploadSucces{
                self.navigationController?.popvc(animated: true)
            }
            
            //self.navigationController?.popvc(animated: true)
            //self.view.hiddenLoading()
            self.view.hiddenLoading()
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)

    }
    
    
}
