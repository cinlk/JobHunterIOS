//
//  SingleReplyViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/13.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import Kingfisher

fileprivate let viewTitle:String = "回帖"

class SingleReplyViewController: BaseViewController {

    
    private lazy var keyboardH:CGFloat = 0
    private lazy var InputViewHeigh:CGFloat = GlobalConfig.toolBarH
    
    
    
    
    // 自己的回贴 可以删除
    internal var mycomment:Bool = false
    //
    internal var currentSenderName:String = ""{
        didSet{
        
            self.inputText.defaultText = "回复\(currentSenderName)"
            //self.inputText.plashold.text = "回复\(currentSenderName)"
        }
    }
    private var currentSelecteCell:Int = -1
    
    
    // 子评论id
    internal var subReplyID:String?
    
    // MARK 上拉刷新 获取回帖内容 和 回复内容, 忽略是回帖 还是自子评论 ！！！
    // 子评论 不能下拉刷新
    // 都可以发布评论
    
    internal var mode:FirstReplyModel?{
        didSet{
            mycomment = mode?.authorID ==  GlobalUserInfo.shared.getId()
            headerView.mode = mode
            currentSenderName = mode!.authorName!
            headerView.layoutSubviews()
            self.table.tableHeaderView = headerView
            
            loadData()
        }
    }
    
    // 子回复
    internal lazy var allSubReplys:[SecondReplyModel] = []
    

    internal lazy var headerView:singleHeaderView = { [unowned self] in
        let view = singleHeaderView()
        view.thumbUP.addTarget(self, action: #selector(like), for: .touchUpInside)
        view.reply.addTarget(self, action: #selector(reply), for: .touchUpInside)
        
        return view
    }()
    
    
    internal lazy var table:UITableView = { [unowned self] in
        let tb = UITableView()
        tb.tableFooterView = UIView()
        tb.backgroundColor = UIColor.viewBackColor()
        tb.dataSource = self
        tb.delegate = self
        tb.keyboardDismissMode = .onDrag
        tb.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: InputViewHeigh + 10, right: 0)
        tb.register(contentCell.self, forCellReuseIdentifier: contentCell.identity())
        
        return tb
    }()
    
    // 回复数据加载 状态进度
    internal lazy var  progressView:UIActivityIndicatorView = {
        let pv = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.whiteLarge)
        pv.center = CGPoint.init(x: GlobalConfig.ScreenW/2, y: GlobalConfig.ScreenH/2)
        pv.color = UIColor.orange
        pv.hidesWhenStopped = true
        return pv
    }()
    
    
  
    
    // 回调父界面 删除数据
    internal var deleteSelf:((_ row: Int)->())?
    internal var row:Int = -1
    
    
    private lazy var deleteAlert:UIAlertController = {
        let alert = UIAlertController.init(title: "确认删除", message: "数据将无法恢复", preferredStyle: UIAlertController.Style.alert)
        
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let delete = UIAlertAction.init(title: "确认", style: UIAlertAction.Style.default, handler: {   [unowned self]   action in
            self.deleteMyself()
        })
        
        
        alert.addAction(cancel)
        alert.addAction(delete)
        return alert
    }()
    
    
    
    
    // 底部输入框view
    private lazy var inputText:ChatInputView = {
        let text = ChatInputView.init(frame: CGRect.init(x: 0, y: GlobalConfig.ScreenH - InputViewHeigh , width: GlobalConfig.ScreenW, height: InputViewHeigh))
        text.plashold.text = "回复\(currentSenderName)"
        text.delegate = self
        text.isHidden = true
        return text
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.insertCustomerView()
        self.navigationItem.title = viewTitle
        UIApplication.shared.keyWindow?.addSubview(inputText)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.removeCustomerView()
        self.navigationItem.title = ""
        inputText.removeFromSuperview()
    }

    
    override func setViews(){

        self.view.addSubview(table)
        self.hiddenViews.append(table)
        self.table.addSubview(progressView)
        
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
        
        
        //简体键盘
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        super.setViews()
        
        
    }
    
    override func didFinishloadData(){
        super.didFinishloadData()
        progressView.stopAnimating()
        
        if mycomment{
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "rabbish"), style: .plain, target: self, action: #selector(showAlert))
        }
        self.inputText.isHidden = false
        
        self.table.reloadData()
    }
    
    override  func reload() {
        super.reload()
        self.loadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    
}


// table

extension SingleReplyViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSubReplys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: contentCell.identity(), for: indexPath) as? contentCell{
            cell.mode = allSubReplys[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = allSubReplys[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: contentCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.inputText.chatView.endEditing(true)
        //currentReceiverName = mode.authorName!
        currentSelecteCell = indexPath.row
        
        if  allSubReplys[indexPath.row].authorID == GlobalUserInfo.shared.getId() {
            buildAlert(showDelete: true)
        }
        buildAlert(showDelete: false)
      

    }
    
    //section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    
    
}



extension SingleReplyViewController{
    
    private func buildAlert(showDelete:Bool){
        
        let vc = UIAlertController.init(title: "请选择", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let thumbUP = UIAlertAction.init(title: "赞", style: UIAlertAction.Style.default, handler: { [weak self] action in
            guard let `self` = self else{
                return
            }
            if  self.allSubReplys[self.currentSelecteCell].isLike{
                self.allSubReplys[self.currentSelecteCell].thumbUP -= 1
            }else{
                self.allSubReplys[self.currentSelecteCell].thumbUP += 1
                
            }
            self.allSubReplys[self.currentSelecteCell].isLike = !self.allSubReplys[self.currentSelecteCell].isLike
            
            
            self.table.reloadRows(at: [IndexPath.init(row: self.currentSelecteCell, section: 0)], with: .automatic)
            
        })
        
        let comment = UIAlertAction.init(title: "评论", style: .default, handler: { [weak self]  action in
            guard let `self` = self else{
                return
            }
            let name  = self.allSubReplys[self.currentSelecteCell].authorName!
            
            self.resetPlashold(name: name)
            
            self.inputText.chatView.becomeFirstResponder()
        })
        
        // 自己的评论
        let delete = UIAlertAction.init(title: "删除", style: UIAlertAction.Style.destructive, handler: { [weak self] action in
            guard let `self` = self else{
                return
            }
            // 服务器端删除
            self.allSubReplys.remove(at: self.currentSelecteCell)
            self.table.reloadData()
        })
        
        
        vc.addAction(thumbUP)
        vc.addAction(comment)
        if showDelete{
            vc.addAction(delete)
        }
        vc.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        
        self.present(vc, animated: true, completion: nil)

    }
    
}




extension SingleReplyViewController{
    @objc private func like(){
        if mode!.isLike == true {
            mode?.isLike = false
            mode?.thumbUP -= 1
            headerView.thumbUP.setTitle(String(mode!.thumbUP), for: .normal)
            //tableHeader.thumbUP.isSelected = false
            headerView.thumbUP.tintColor = UIColor.lightGray
             return
            
        }
        // 上传到服务器
        mode?.isLike = true
        mode?.thumbUP += 1
        headerView.thumbUP.setTitle(String(mode!.thumbUP), for: .normal)
        //tableHeader.thumbUP.isSelected = true
        headerView.thumbUP.tintColor = UIColor.blue
    }
    
    @objc private func reply(){
        if self.inputText.chatView.isFirstResponder{
            self.inputText.chatView.resignFirstResponder()
            return
        }
        self.inputText.chatView.becomeFirstResponder()
        
        
        self.resetPlashold(name: self.mode!.authorName!)
      
        
    }
    
    @objc private func showAlert(){
        self.present(deleteAlert, animated: true, completion: nil)

    }
    
    private func deleteMyself(){
        
        // 服务器删除
        // 返回父界面
        self.navigationController?.popvc(animated: true)

         self.deleteSelf?(self.row)
        
    }
   
    
}


extension SingleReplyViewController{
    
    @objc private func keyboardShow(notify:NSNotification){
        
        
        let kframe = notify.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let duration = notify.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        let curve = notify.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber
        
        keyboardH = kframe.height
        
        UIView.animate(withDuration: TimeInterval(truncating: duration), delay: 0, options: [UIView.AnimationOptions.init(rawValue: UInt(truncating: curve))], animations: {
            
            self.inputText.frame.origin.y = GlobalConfig.ScreenH - self.keyboardH  - self.InputViewHeigh
            
            
        }, completion: nil)
        
        
        
    }
    
    @objc private func keyboardHidden(notify:NSNotification){
        
        let duration = notify.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        let curve = notify.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber
        keyboardH = 0
        
 
        
        UIView.animate(withDuration: TimeInterval(truncating: duration), delay: 0, options: [.curveEaseIn,UIView.AnimationOptions.init(rawValue: UInt(truncating: curve))], animations: {
            self.inputText.frame.origin.y = GlobalConfig.ScreenH - self.InputViewHeigh
            
            
        }, completion: { bool in
             
            //self.currentSelecteCell = -1
            self.resetPlashold(name: self.mode!.authorName!)
            
        })
        
    }
    
    // 更新 发送对象
    private func resetPlashold(name:String){
        self.currentSenderName = name
        if self.self.inputText.chatView.text.isEmpty{
            self.inputText.plashold.text = "回复\(self.currentSenderName)"
        }
    }
    
}

extension SingleReplyViewController: ChatInputViewDelegate{
    
    func changeBarHeight(textView: UITextView, height: CGFloat) {
        let pointY:CGFloat = GlobalConfig.ScreenH - keyboardH - GlobalConfig.toolBarH - height
        //print(height)
        if height == 0 {
            InputViewHeigh = GlobalConfig.toolBarH
            
            self.inputText.frame = CGRect.init(x: 0, y: pointY, width: GlobalConfig.ScreenW, height: InputViewHeigh)
        }else{
            InputViewHeigh = GlobalConfig.toolBarH + height
            self.inputText.frame = CGRect.init(x: 0, y: pointY, width: GlobalConfig.ScreenW, height: InputViewHeigh)
        }
        
    }
    
    func sendMessage(textView: UITextView) {
        if let text = textView.text, let new = SecondReplyModel(JSON: [
            "id": (self.mode?.id)!,
            "replyID": (self.mode?.replyID)!,
            "subreplyID": getUUID(),
            "replyContent":text,
            "receiver": currentSenderName,
            "authorID": (self.mode?.authorID)!,
            "authorName": (self.mode?.authorName)!,
            "authorIcon":"chicken",
            "colleage":"北京大学",
            "createTime":Date().timeIntervalSince1970,
            "kind":"jobs",
            "isLike":false,
            "thumbUP":0,
            "reply":0]){
            allSubReplys.append(new)
            self.table.reloadData()
        }
    }
    
    
}
// 获取数据
extension SingleReplyViewController{
    internal func loadData(){
        
        progressView.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async {  [weak self] in
            
            Thread.sleep(forTimeInterval: 3)
            
            
            if self?.subReplyID == nil {
                
                
                // 获取部分回复（最旧的的5条）
                for _ in 0..<5{
                    self?.allSubReplys.append(SecondReplyModel(JSON: ["id":"dwqdw","replyID":getUUID(), "subreplyID":"dqwd-dqwdqwd","replyContent":"当前为多群多低级趣味的精品区 当前为多   dqwdqwdqwd   当前为多群 当前为多群 dqdqw","receiver":"小猪啊","authorID":"dqwddqwdd","authorName":"我的名字当前为多","authorIcon":"chicken","colleage":"北京大学","createTime":Date().timeIntervalSince1970,"kind":"jobs","isLike":false,"thumbUP":10,"reply":22] )!)
                }
                
                
            }else if let subReplyID =  self?.subReplyID{
                // 根据评论id  获取它附件部分回复，（不显示回帖）
                    for _ in 0..<2{
                        self?.allSubReplys.append(SecondReplyModel(JSON: ["id":"dwqdw","replyID":getUUID(), "subreplyID":"123dqwdqwd456","replyContent":"当前为多群多低级趣味的精品区 当前为多   dqwdqwdqwd   当前为多群 当前为多群 dqdqw","receiver":"小猪啊","authorID":"123456","authorName":"我的名字当前为多","authorIcon":"chicken","colleage":"北京大学","createTime":Date().timeIntervalSince1970,"kind":"jobs","isLike":false,"thumbUP":2303,"reply":101] )!)
                    }
                    
                    self?.allSubReplys.append(SecondReplyModel(JSON: ["id":"dwqdw","replyID":getUUID(), "subreplyID":subReplyID,"replyContent":"当前为多群多低级趣味的精品区 当前为多   dqwdqwdqwd   当前为多群 当前为多群 dqdqw","receiver":"小猪啊","authorID":"123456","authorName":"我的名字当前为多","authorIcon":"chicken","colleage":"北京大学","createTime":Date().timeIntervalSince1970,"kind":"jobs","isLike":false,"thumbUP":2303,"reply":101] )!)
                    
                    for _ in 0..<5{
                        self?.allSubReplys.append(SecondReplyModel(JSON: ["id":"dwqdw","replyID":getUUID(), "subreplyID":"123dqwdqwd456","replyContent":"当前为多群多低级趣味的精品区 当前为多   dqwdqwdqwd   当前为多群 当前为多群 dqdqw","receiver":"小猪啊","authorID":"123456","authorName":"我的名字当前为多","authorIcon":"chicken","colleage":"北京大学","createTime":Date().timeIntervalSince1970,"kind":"jobs","isLike":false,"thumbUP":2303,"reply":101] )!)
                    }
            }
            
           
            
            
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
                // 错误处理！！！
            })
        }
    }
}




internal class  singleHeaderView:PostHeaderView{
 
    
    internal var mode:FirstReplyModel?{
        didSet{
            guard  let mode = mode  else {
                return
            }
            if let url = mode.authorIcon{
              self.userIcon.kf.indicatorType = .activity
              self.userIcon.kf.setImage(with: Source.network(url), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            self.userName.text = mode.authorName
            //self.userIcon.image = UIImage.init(named: mode.authorIcon)
            self.createTime.text = mode.createTimeStr
            self.contentText.text = mode.replyContent
            
            // 计算contentText高度
            let contentSize = self.contentText.sizeThatFits(CGSize.init(width: GlobalConfig.ScreenW, height: CGFloat(MAXFLOAT))
            )
            _ = self.contentText.sd_layout().heightIs(contentSize.height)
            
            // 更加数字长度 调整btn长度
            let replyStr = String(mode.reply)
            let replySize = NSString(string: replyStr).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
            self.reply.setTitle(replyStr, for: .normal)
            // 25 是image 的长度
            _ = self.reply.sd_layout().widthIs(25 + replySize.width)
            let thumbStr = String(mode.thumbUP)
            let thumbSize = NSString(string: thumbStr).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
            _ = self.thumbUP.sd_layout().widthIs(25 + thumbSize.width)
            self.thumbUP.setTitle(thumbStr, for: .normal)
            
            userName.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 45 - 10  -  thumbUP.width - reply.width)
            
            self.setupAutoHeight(withBottomView: self.contentText, bottomMargin: 10)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        thumbUP.sd_clearAutoLayoutSettings()
        reply.sd_clearAutoLayoutSettings()
        userName.setMaxNumberOfLinesToShow(2)
        lines.isHidden = true
        _ = thumbUP.sd_layout().rightSpaceToView(self,10)?.topEqualToView(userName)?.widthIs(0)?.heightIs(25)
        _ = reply.sd_layout().rightSpaceToView(thumbUP,0)?.topEqualToView(thumbUP)?.heightRatioToView(thumbUP,1)?.widthIs(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// cell
@objcMembers internal class contentCell:ForumBaseCell{
    
    dynamic internal var mode:SecondReplyModel?{
        didSet{
            guard let mode = mode else {
                return
            }
         
            if let url = mode.authorIcon{
                self.authorIcon.kf.indicatorType = .activity
                self.authorIcon.kf.setImage(with: Source.network(url), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            self.creatTime.text = mode.createTimeStr
            //self.authorIcon.image = UIImage.init(named: mode.authorIcon)
            self.postType.text = ""
            
            let authNameStr = NSMutableAttributedString.init(string: mode.authorName!, attributes: [NSAttributedString.Key.foregroundColor:UIColor.black, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
            authNameStr.append(NSAttributedString.init(string: " " + mode.colleage!, attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]))
            
            self.authorName.attributedText = authNameStr
            
            
            
            let talkto = NSAttributedString.init(string: " 回复 ")
            let receiver = NSMutableAttributedString.init(string: mode.receiver!)
            receiver.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue], range: NSRange.init(location: 0, length: mode.receiver!.count))
            receiver.append(NSAttributedString.init(string: ": "))
            
            let content = NSMutableAttributedString.init(string: mode.replyContent!)
            
            
            
            let attrStr = NSMutableAttributedString.init()
            attrStr.append(talkto)
            attrStr.append(receiver)
            attrStr.append(content)
            self.postTitle.attributedText = attrStr
            
            
            
            // 点赞
            let ts = String(mode.thumbUP)
            let thumbStr = NSMutableAttributedString.init(string: ts)
            thumbStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], range: NSRange.init(location: 0, length: ts.count))
            let attch = NSTextAttachment.init()
            if mode.isLike{
                 attch.image = UIImage.init(named: "selectedthumbup")?.withRenderingMode(.alwaysTemplate)
            }else{
                 attch.image = UIImage.init(named: "thumbup")?.withRenderingMode(.alwaysTemplate).imageWithColor(color: UIColor.lightGray)
            }
           
            // 图片和文字水平对齐
            attch.bounds = CGRect.init(x: 0, y: (UIFont.systemFont(ofSize: 12).capHeight - 15)/2, width: 15, height: 15)
            
            let tmp = NSMutableAttributedString.init(attributedString: NSAttributedString.init(attachment: attch))
            tmp.append(thumbStr)
            let width1 = tmp.boundingRect(with: CGSize.init(width: 100, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: nil).width + 10
            
            self.thumbs.attributedText = tmp
            _ = self.thumbs.sd_layout().widthIs(width1)
            
            
            self.setupAutoHeight(withBottomView: self.creatTime, bottomMargin: 10)
        }
    }
    
    
    override var isHighlighted: Bool{
        didSet{
            if isHighlighted{
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.backgroundColor = UIColor.orange
                }) { bool in
                    self.backgroundColor = UIColor.white
                    self.isHighlighted = false
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.postType.isHidden = true
        self.reply.isHidden = true
        self.postType.isAttributedContent = true
        self.postTitle.font = UIFont.systemFont(ofSize: 16)
        self.postTitle.setMaxNumberOfLinesToShow(-1)
        
     
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "contentCell"
    }
    
}
