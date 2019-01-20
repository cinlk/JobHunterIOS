//
//  EditPostViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/9.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let titleTextH:CGFloat = 38
fileprivate var contentTextH:CGFloat = 250

class EditPostViewController: UIViewController {


    // post data test
    private struct postBody {
        var title:String
        var content:String
        var type:String
        
        init(title:String,content:String,type:String) {
            self.title = title
            self.content = content
            self.type = type
        }
    }
    
    
    private lazy var data: postBody = postBody(title: "", content: "", type: "")
 
    fileprivate  lazy var titleView:mytext = { [unowned self] in
        let view = mytext(frame: CGRect.zero)
        view.placehold.text = "标题"
        view.words.text = "0"
        view.total.text = "/120"
        view.placehold.font = UIFont.boldSystemFont(ofSize: 18)
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.delegate = self
        view.vc = self
        view.isScrollEnabled = false
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
     fileprivate  lazy var contentView:mytext = {
        let view = mytext()
        view.placehold.text = "请输入内容"
        view.placehold.font = UIFont.systemFont(ofSize: 16)
        view.delegate = self
        view.vc = self
        view.words.text = "0"
        view.total.text = "/10000"
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        //view.layer.addSublayer(border)
        view.layer.masksToBounds = true

        view.showsVerticalScrollIndicator = true
        view.font = UIFont.systemFont(ofSize: 16)
        return view
    }()
    
    //
    
    private lazy var types:ForumTopicTypeViewController =  { [unowned self] in
        let vc = ForumTopicTypeViewController()
        vc.getType = { type in
            self.contentView.postType.title = type.describe
            self.titleView.postType.title = type.describe
            self.data.type = type.rawValue
        }
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setViews()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.insertCustomerView()
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.removeCustomerView()
     }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   

}


extension EditPostViewController{
    private func setViews(){
        
        self.title = "发布帖子"
        // 影藏返回按钮文字
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发布", style: .plain, target: self, action: #selector(post))
        self.view.addSubview(titleView)
        self.view.addSubview(contentView)
    
        
        _ = titleView.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.view,GlobalConfig.NavH)?.heightIs(titleTextH)
        
        _ = contentView.sd_layout().topSpaceToView(titleView,0)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.heightIs(contentTextH)
        
        
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        
    }
    
}


extension EditPostViewController:UITextViewDelegate{
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        //textView.contentOffset = CGPoint.zero
        
        if textView == titleView{
            (textView as! mytext).placehold.text =  textView.text.isEmpty ? "标题" : ""
            
        }else if textView == contentView{
            (textView as! mytext).placehold.text =  textView.text.isEmpty ? "请输入内容" : ""
            
        }
        
        
        
    }
    
    
    // 禁止换行和空格
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if textView == titleView{
            if text == "\n" || text == "\t" {
                return false
            }
        }
        
        return true
        
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        //textView.contentOffset = CGPoint.zero
        let size = textView.sizeThatFits(CGSize.init(width: GlobalConfig.ScreenW, height: CGFloat(MAXFLOAT)))
        
        if textView == titleView{
            (textView as! mytext).placehold.text =  textView.text.isEmpty ? "标题" : ""
            // 一共3行
            
            
            //  防止contentView 向上偏移
            textView.scrollRangeToVisible(textView.selectedRange)
            // 限制字数
            if textView.text.count > 120 {
                let start = textView.text.startIndex
                let end = textView.text.index(start, offsetBy: 120)
                textView.text = String(textView.text[start..<end])
                
                return
            }
            (textView as! mytext).words.text = String(textView.text.count)

            
            _ = textView.sd_layout().heightIs(size.height)
           
            
            
        }else if textView == contentView{
            (textView as! mytext).placehold.text =  textView.text.isEmpty ? "请输入内容" : ""
            textView.scrollRangeToVisible(textView.selectedRange)
            if textView.text.count > 10000 {
                let start = textView.text.startIndex
                let end = textView.text.index(start, offsetBy: 10000)
                textView.text = String(textView.text[start..<end])
                
                return
            }
            
            (textView as! mytext).words.text = String(textView.text.count)

            
        }
    }
    
    // 结束编辑
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView == titleView{
            data.title = textView.text
        }else{
            data.content = textView.text
        }
    
    }
    
    
    
    
    
    
}



extension EditPostViewController{
    
    @objc private func keyboardShow(notify:NSNotification){
        
        
        let kframe = notify.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        // 加上toolbar 高度30
        if contentTextH + GlobalConfig.NavH + titleTextH > GlobalConfig.ScreenH - (kframe.height + 30){
            _ = contentView.sd_resetLayout()
            contentTextH = GlobalConfig.ScreenH - (kframe.height + 30) - GlobalConfig.NavH - titleTextH
            _ = contentView.sd_layout().topSpaceToView(titleView,0)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.heightIs(contentTextH)
            
        }
      
    }
}

extension EditPostViewController{
    @objc private func post(){
        // 检查字数  和条件
        self.view.endEditing(true)
        if data.title == "" || data.content == "" || data.type == ""{
            return
        }
        
        // 发送到服务七 获取id数据 和 icon 等数据
        
        // 构造postArticle 数据
        if let article = PostArticleModel(JSON: ["id":getUUID(),"title":"文字标题等等","authorID":myself.userID,
                                                 "authorName":myself.name,"colleage":"我的大学","authorIcon":myself.icon,"createTime":Date().timeIntervalSince1970,"kind":data.type]){
            
            NotificationCenter.default.post(name: Notification.Name.init(data.type), object: nil, userInfo: ["mode":article])

        }
        // 通知 不同的板块刷新
        
        //print(data.content,data.type,data.title)
        self.navigationController?.popvc(animated: true)

     }
}

extension EditPostViewController{
    @objc private func chooseType(){
        
        self.navigationController?.pushViewController(types, animated: true)
    }
    
    @objc private func hidKeyboard(){
        self.view.endEditing(true)
    }
}



private class mytext:UITextView{
    
    internal weak var vc:EditPostViewController?
    
    internal var placehold:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
        return label
    }()
    
    // toolbar
    internal lazy var toolBar:UIToolbar = { [unowned self] in
        let bar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: 30))
        bar.barStyle = .default
        bar.backgroundColor = UIColor.viewBackColor()
        return bar
    }()
    
    //类型选择
    internal  lazy var postType:UIBarButtonItem = UIBarButtonItem.init(title: "选择板块", style: .plain, target: vc, action: "chooseType")
    // 图片
    
    
    // 影藏键盘
    
    internal lazy var hiddenKeyboard:UIBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "keyboard")?.changesize(size: CGSize.init(width: 25, height: 25)).withRenderingMode(.alwaysTemplate), style: .plain, target: vc, action: "hidKeyboard")
    
    
    
    internal lazy var words:UILabel = {
        let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: 50, height: 35))
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.textAlignment = .right
 
        return label
    }()
    
    internal lazy var total:UILabel = {
        let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: 50, height: 35))
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.text = ""
        return label
    }()
    
    
    private lazy var wordCount:UIBarButtonItem = UIBarButtonItem.init(customView: words)
    private lazy var totalCount:UIBarButtonItem = UIBarButtonItem.init(customView: total)
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(placehold)
        _ = placehold.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self,5)?.autoHeightRatio(0)
        placehold.setMaxNumberOfLinesToShow(2)
        
        // 附加view
        self.inputAccessoryView = toolBar
        
        //
        let space2 = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        space2.width  =  200
        let space1 = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space1.width = 10
        
        
        toolBar.items = [postType,space1,wordCount,totalCount, space2, hiddenKeyboard]
        
        
    }
    
    
}
