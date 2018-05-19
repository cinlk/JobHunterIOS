//
//  PostCommentViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/13.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class PostCommentViewController: UIViewController {

    
    
    
    private var content:String = ""
    
    internal var postBack:((_ content:String)->Void)?
    
    
    private lazy var top: topView = {  [unowned self] in
        let top = topView()
        top.cancel.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        top.post.addTarget(self, action: #selector(post), for: .touchUpInside)
        top.viewTitle.text = self.title!
        return top
        
    }()
    
    
    private lazy var text:UITextView = { [unowned self] in
        let text = UITextView()
        text.textColor = UIColor.black
        text.font = UIFont.systemFont(ofSize: 16)
        text.delegate = self
    
        return text
        
    }()
    
    
    // 改变状态栏为白色
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.viewBackColor()
        self.view.addSubview(top)
        self.view.addSubview(text)
        _ = top.sd_layout().topEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.heightIs(NavH)
        _ = text.sd_layout().topSpaceToView(top,0)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.heightIs(200)
        

        // Do any additional setup after loading the view.
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


extension PostCommentViewController{
    @objc private func cancel(){
        self.text.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func post(){
        // 提交数据, 不为空
        
        self.text.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
}

extension PostCommentViewController:UITextViewDelegate{
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if !textView.text.isEmpty{
            content = textView.text
            self.postBack?(content)
            
        }
    }
}


fileprivate class topView:UIView{
    
    
    internal var viewTitle:UILabel = {
        let title = UILabel()
        title.setSingleLineAutoResizeWithMaxWidth(200)
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = UIColor.white
        return title
    }()
    
    internal var cancel:UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitle("取消", for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor.clear
        btn.contentVerticalAlignment = .bottom
        
        return btn
    }()
    
    internal var post:UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitle("提交", for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor.clear
        btn.contentVerticalAlignment = .bottom

        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(r: 105, g: 105, b: 105)
        let views:[UIView] = [cancel,viewTitle,post]
        self.sd_addSubviews(views)
        _ = cancel.sd_layout().leftSpaceToView(self,10)?.bottomSpaceToView(self,5)?.widthIs(60)?.heightIs(25)
        _ = post.sd_layout().rightSpaceToView(self,10)?.bottomEqualToView(cancel)?.topEqualToView(cancel)?.widthRatioToView(cancel,1)
        _ = viewTitle.sd_layout().centerXEqualToView(self)?.bottomEqualToView(cancel)?.autoHeightRatio(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}






