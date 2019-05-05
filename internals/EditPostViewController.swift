//
//  EditPostViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/9.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate let title:String = "发布帖子"
fileprivate let titleTextH:CGFloat = 38
fileprivate var contentTextH:CGFloat = 250
fileprivate let maxWordCount = [120, 1000]

internal enum textType:String{
    case title
    case content
    case none
}


private class mytext:UITextView{
    
    private weak var vc:EditPostViewController?
    private var type:textType = .none
    
    
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
        
        //
        let space1 = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space1.width = 10
        
        let space2 = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        space2.width  =  200
        
        
        
        bar.items = [postType,space1,wordCount,totalCount, space2, hiddenKeyboard]
        
        return bar
    }()
    
    //类型选择
    internal  lazy var postType:UIBarButtonItem = UIBarButtonItem.init(title: "选择板块", style: .plain, target: vc, action: Selector(("chooseType")))
    // 图片
    
    
    // 影藏键盘
    internal lazy var hiddenKeyboard:UIBarButtonItem = UIBarButtonItem.init(title: "隐藏键盘", style: .plain, target: vc, action: Selector(("hidKeyboard")))
    
    
    
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
    
    private var placeHoldTitle:String = ""
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.delegate = self
        
        
    }
    
    
    
    convenience init(frame: CGRect, type:textType, vc:EditPostViewController?){
        self.init(frame: frame, textContainer: nil)
        self.type = type
        self.vc = vc
        switch type {
        case .title:
            placeHoldTitle = "标题"
            self.words.text = "0"
            self.total.text = "/\(maxWordCount[0])"
            self.placehold.font = UIFont.boldSystemFont(ofSize: 18)
            self.font = UIFont.boldSystemFont(ofSize: 18)
            //view.delegate = self
            //view.vc = self
            self.isScrollEnabled = false
            self.showsVerticalScrollIndicator = false
        case .content:
         
            placeHoldTitle = "请输入内容"
            self.placehold.font = UIFont.systemFont(ofSize: 16)
            //view.delegate = self
            //view.vc = self
            self.words.text = "0"
            self.total.text = "/\(maxWordCount[1])"
            self.layer.borderWidth = 0.5
            self.layer.borderColor = UIColor.lightGray.cgColor
            //view.layer.addSublayer(border)
            self.layer.masksToBounds = true
            
            self.showsVerticalScrollIndicator = true
            self.font = UIFont.systemFont(ofSize: 16)
        default:
            break
            
        }
        
        self.placehold.text = placeHoldTitle
    
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(placehold)
        _ = placehold.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self,5)?.autoHeightRatio(0)
        placehold.setMaxNumberOfLinesToShow(2)
        
        // 输入栏 上方view
        self.inputAccessoryView = toolBar
    }
    
    
}

extension mytext: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        (textView as! mytext).placehold.text =  textView.text.isEmpty ? self.placeHoldTitle : ""
    }
    
    // 禁止标题换行和空格
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if self.type == .title{
            if text == "\n" || text == "\t"{
                return false
            }
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.vc?.changeData(type: self.type, content: textView.text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize.init(width: GlobalConfig.ScreenW, height: CGFloat(MAXFLOAT)))
        (textView as! mytext).placehold.text = textView.text.isEmpty ? placeHoldTitle : ""
        textView.scrollRangeToVisible(textView.selectedRange)

        var count = 0
        switch self.type {
        case .title:
           count = maxWordCount[0]
            _ = textView.sd_layout()?.heightIs(size.height)
        case .content:
            count = maxWordCount[1]
        default:
            break
        }
        
        if textView.text.count > count {
            let start = textView.text.startIndex
            let end = textView.text.index(start, offsetBy: count)
            textView.text = String(textView.text[start..<end])
            return
        }
        
        (textView as! mytext).words.text = String(textView.text.count)

    }
}


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
        
        func validate() -> Bool{
            return title != "" && content != "" && type != ""
        }
    }
    
    
    private lazy var data: postBody = postBody(title: "", content: "", type: "")
 
    fileprivate  lazy var titleView:mytext = { [unowned self] in
        let view = mytext.init(frame: CGRect.zero, type: .title, vc: self)
        return view
    }()
    
     fileprivate  lazy var contentView:mytext = { [unowned self] in
        let view = mytext.init(frame: CGRect.zero, type: .content, vc: self)
        return view
    }()
    
    
    private lazy var types:ForumTopicTypeViewController =  { [unowned self] in
        let vc = ForumTopicTypeViewController()
        vc.getType = { [weak self] type in
            guard let `self` = self else {
                return
            }
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
    
    deinit {
        print("deinit editPostViewController \(self)")
    }

}


extension EditPostViewController{
    private func setViews(){
        
        self.title = title
        // 影藏返回按钮文字
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发布", style: .plain, target: self, action: #selector(post))
        self.view.addSubview(titleView)
        self.view.addSubview(contentView)
    
        
        _ = titleView.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(self.view,GlobalConfig.NavH)?.heightIs(titleTextH)
        
        _ = contentView.sd_layout().topSpaceToView(titleView,0)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.heightIs(contentTextH)
        
        
       _ =  NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification, object: nil).takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self] (notify) in
        
            guard let `self` = self else {
                return
            }
        
            let kframe = notify.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            // 加上toolbar 高度30
            // 如果覆盖了键盘，缩小contentview 的高度
        
            if contentTextH + GlobalConfig.NavH + titleTextH > GlobalConfig.ScreenH - (kframe.height + 30){
                _ = self.contentView.sd_resetLayout()
                contentTextH = GlobalConfig.ScreenH - (kframe.height + 30) - GlobalConfig.NavH - titleTextH
                _ = self.contentView.sd_layout().topSpaceToView(self.titleView,0)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.heightIs(contentTextH)
                
            }
        
        }, onError: nil, onCompleted: nil, onDisposed: nil)
    }
    
}


extension EditPostViewController{
    
    internal func changeData(type:textType, content:String){
        switch type {
        case .title:
            self.data.title = content
        case .content:
            self.data.content = content
        default:
            break
        }
        
    }
}


extension EditPostViewController{
    @objc private func post(){
        // 检查字数  和条件
        self.view.endEditing(true)
        
        guard  self.data.validate() else {
            return
        }
         
        
        // 发送到服务七 获取id数据 和 icon 等数据
        
        // 构造postArticle 数据
//        if let article = PostArticleModel(JSON: ["id":Utils.getUUID(),"title":"文字标题等等","authorID": GlobalUserInfo.shared.getId()! ,
//                                                 "authorName": GlobalUserInfo.shared.getName() ?? "","colleage":"我的大学","authorIcon": GlobalUserInfo.shared.getIcon()?.absoluteString ?? "" ,"createTime":Date().timeIntervalSince1970,"kind":data.type]){
//
//            NotificationCenter.default.post(name: Notification.Name.init(data.type), object: nil, userInfo: ["mode":article])
//
//        }
        // 发送给服务器 TODO
        // 成功后，通知界面刷新？ 或者等待审核后在
        // 返回
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


