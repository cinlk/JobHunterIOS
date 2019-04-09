//
//  PostContentViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import Kingfisher
 
fileprivate let viewTitle:String = "帖子详情"
fileprivate let shareViewH = SingletoneClass.shared.shareViewH


class PostContentViewController: BaseTableViewController {

    
    private lazy var keyboardH:CGFloat = 0
    private lazy var InputViewHeigh:CGFloat = GlobalConfig.toolBarH
    
    
 
    // 自己的帖子 可以删除
    internal var mypost:Bool = false
    
    private lazy var tableHeader:contentHeaderView = {
        let header = contentHeaderView()
        header.thumbUP.addTarget(self, action: #selector(like), for: .touchUpInside)
        header.reply.addTarget(self, action: #selector(comment), for: .touchUpInside)
        header.share.addTarget(self, action: #selector(showShare), for: .touchUpInside)
        header.collected.addTarget(self, action: #selector(collect), for: .touchUpInside)
        return header
    }()
    
    // 发帖内容数据
    private  var contentMode:PostContentModel?
    // 回帖数据
    private  var replyModels:[FirstReplyModel] = []
    
    
    //
    internal var mode:(data:PostArticleModel, row:Int)?{
        didSet{
            self.loadData()
        }
    }
    
    
    // 来自消息界面
    internal var postID:String?{
        didSet{
            self.loadData()
        }
    }
    
    
    
    
    
    // 分享view
    private lazy var shareV:ShareView = {
        let share = ShareView.init(frame: CGRect.init(x: 0, y: GlobalConfig.ScreenH, width: GlobalConfig.ScreenW, height: shareViewH))
        share.delegate = self
        return share
    }()
    
    
    
    internal var defaultText:String = "输入评论(不能超过200字)"
    
    // 底部输入框view
    private lazy var inputText:ChatInputView = {
        let text = ChatInputView.init(frame: CGRect.init(x: 0, y: GlobalConfig.ScreenH - InputViewHeigh , width: GlobalConfig.ScreenW, height: InputViewHeigh))
        text.defaultText = self.defaultText
        text.plashold.text = self.defaultText
        text.delegate = self
        text.isHidden = true
        return text
    }()
    
    
    // 论坛列表父界面 删除数据
    internal var deleteSelf:((_ row: Int)->())?
    
    private lazy var deleteAlert:UIAlertController = { [unowned self] in
        let alert = UIAlertController.init(title: "确认删除", message: "数据将无法恢复", preferredStyle: UIAlertController.Style.alert)
        
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let delete = UIAlertAction.init(title: "确认", style: UIAlertAction.Style.default, handler: { action in
            self.deleteMyself()
        })
        
        
        alert.addAction(cancel)
        alert.addAction(delete)
        return alert
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.insertCustomerView()
        UIApplication.shared.keyWindow?.addSubview(shareV)
        UIApplication.shared.keyWindow?.addSubview(inputText)


    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        shareV.removeFromSuperview()
        inputText.removeFromSuperview()
        
        
    }
    
    override func setViews() {
        
        self.title = viewTitle
        
        self.tableView.tableFooterView = UIView()
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.register(ReplyPostTableViewCell.self, forCellReuseIdentifier: ReplyPostTableViewCell.identity())
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: GlobalConfig.toolBarH + 10, right: 0)
    
        //简体键盘
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //self.navigationController?.toolbar.autoresizingMask = [.flexibleHeight, .flexibleTopMargin]
        
        
        super.setViews()
    }
    
    
    
    
    
    override func didFinishloadData() {
        super.didFinishloadData()
        
        self.tableHeader.mode = self.contentMode!
        self.tableHeader.layoutSubviews()
        self.tableView.tableHeaderView = self.tableHeader
        self.mypost = contentMode?.authorID == GlobalUserInfo.shared.getId()
        self.inputText.isHidden = false
        
        if mypost{
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "rabbish"), style: .plain, target: self, action: #selector(showAlert))
        }
        
        self.tableView.reloadData()
        
    }
    
    
    private func notFound(){
        super.didFinishloadData()
        self.tableView.showToast(title: "没有找找404", customImage: nil, mode: .text)
        //showOnlyTextHub(message: "没有找找404", view: self.tableView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.navigationController?.popvc(animated: true)

        }
    }
    
    override func reload() {
        super.reload()
        loadData()
    }
    
    
    // table
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replyModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ReplyPostTableViewCell.identity(), for: indexPath) as? ReplyPostTableViewCell{
            cell.mode = replyModels[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = replyModels[indexPath.row]
        return  tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: ReplyPostTableViewCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.inputText.chatView.endEditing(true)
        // 跳转到子回复界面
        let vc  = SingleReplyViewController()
        
        vc.mode = replyModels[indexPath.row]
        vc.row = indexPath.row
        vc.deleteSelf = { row in
            self.replyModels.remove(at: row)
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

}



extension PostContentViewController{
    @objc private func showAlert(){
        self.present(deleteAlert, animated: true, completion: nil)
        
        
    }
    
    @objc private func showShare(){
        shareV.showShare()
        
    }
    
    private func deleteMyself(){
        
        // 服务器删除
        
        
        // 从论坛界面操作
        if mode != nil {
            self.navigationController?.popvc(animated: true)

            self.deleteSelf?((self.mode?.row)!)
        }
       
        
        
        // 从消息界面操作, 返回论坛消息
        if postID != nil,  let count = self.navigationController?.viewControllers.count, count  >= 3 {
            let target = self.navigationController?.viewControllers[count - 3]
            self.navigationController?.popToViewController(target!, animated: true)

        }
        
    }
}




// 点赞 评论 和分享

extension PostContentViewController{
    
    @objc private func like(){
        
        if contentMode!.isLike == true {
            contentMode?.isLike = false
            contentMode?.thumbUP -= 1
            tableHeader.thumbUP.setTitle(String(contentMode!.thumbUP), for: .normal)
            //tableHeader.thumbUP.isSelected = false
            tableHeader.thumbUP.isSelected = false
            return
            
        }
        // 上传到服务器
        contentMode?.isLike = true
        contentMode?.thumbUP += 1
        tableHeader.thumbUP.setTitle(String(contentMode!.thumbUP), for: .normal)
        tableHeader.thumbUP.isSelected = true
        //tableHeader.thumbUP.tintColor = UIColor.blue

        
    }
    
    @objc private func comment(){
        if self.inputText.chatView.isFirstResponder{
            self.inputText.chatView.resignFirstResponder()
            return
        }
        self.inputText.chatView.becomeFirstResponder()
    }
    
 
    
    @objc private func collect(){
        tableHeader.collected.isSelected = !(contentMode?.collected)!
        contentMode?.collected = !(contentMode?.collected)!
        
    }
}



// 分享代理实现
extension PostContentViewController: shareViewDelegate{
    
   
    func handleShareType(type: UMSocialPlatformType, view: UIView){
        
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
        shareV.dismiss()
    }
}



// 监听键盘 改变toolbar 位置
extension PostContentViewController{
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
            

        }, completion: nil)
        
    }
    
}




// 输入框delegate 代理
extension PostContentViewController: ChatInputViewDelegate{
    
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
    
    // 添加新的评论，当前放到最后一行
    func sendMessage(textView: UITextView) {
        if let text = textView.text {
           
            if let new = FirstReplyModel(JSON: ["id":"dqwd-dqwdqwd","title":"我的测试","replyContent":text,"authorID":"dqwddqwdd","authorName":"就是我","authorIcon":"chrome","colleage":"天津大学","createTime":Date().timeIntervalSince1970,"kind":"jobs","isLike":false,"thumbUP":0,"reply":0]){
                
                replyModels.append(new)
                self.tableView.reloadData()
                // 滑动出现 contentoffset 偏移过多
                //self.tableView.scrollToRow(at: IndexPath.init(row: replyModels.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
        // 发送 数据  刷新table
       
        //print(textView.text)
    }
    
    
    
}


extension PostContentViewController{
    private func loadData(){
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            Thread.sleep(forTimeInterval: 1)
            
            // 根据post id 加载
            
            self?.contentMode = PostContentModel(JSON: ["id":"dqwd-dqwdqwd","collected":false,"isLike":false,"title":"标题题","content":"发帖内容当前为多群多群 \n 当前的群无多 \n 当前为多群无","colleage":"北京大学", "authorID":"123456","authorName":"dqwdw","authorIcon":"chicken","createTime":Date().timeIntervalSince1970,"kind":"jobs","thumbUP":56,"reply":12])!

            for _ in 0..<10{
                self?.replyModels.append(FirstReplyModel(JSON: ["id":"dqwd-dqwdqwd","replyID":getUUID(),"title":"标题题","replyContent":"当前为多群多低级趣味的精品区\n 当前为多      \t     dqwdqwdqwd   当前为多群\n 当前为多群 dqdqw","authorID":"123456","authorName":"我的名字当前为多群无多群dqwddqwd 当前为多群无多群无当前的群","authorIcon":"chicken","colleage":"北京大学","createTime":Date().timeIntervalSince1970,"kind":"jobs","isLike":false,"thumbUP":15,"reply":89])!)
            }
            
            
            DispatchQueue.main.async(execute: {
                //self?.notFound()
                self?.didFinishloadData()
            })
            
        }
        
    }
}

// 内容头部
fileprivate class contentHeaderView:PostHeaderView{
    
    internal var mode:PostContentModel?{
        didSet{
            guard let mode = mode  else {
                return
            }
            if let url = mode.authorIcon{
                self.userIcon.kf.setImage(with: Source.network(url), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            }
            self.contentTitle.text = mode.title
            //self.userIcon.image = UIImage.init(named: mode.authorIcon)
            
            let authNameStr = NSMutableAttributedString.init(string: mode.authorName!, attributes: [NSAttributedString.Key.foregroundColor:UIColor.black, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
            authNameStr.append(NSAttributedString.init(string: " " + mode.colleage!, attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]))
            
            self.userName.attributedText = authNameStr
            
           
            self.createTime.text = "发布于 " + mode.createTimeStr
            self.contentText.text = mode.content
            // 计算contentText高度
            let contentSize = self.contentText.sizeThatFits(CGSize.init(width: GlobalConfig.ScreenW, height: CGFloat(MAXFLOAT))
            )
            _ = self.contentText.sd_layout().heightIs(contentSize.height)
            
            // 更加数字长度 调整btn长度
            let replyStr = String(mode.reply)
            let replySize = NSString(string: replyStr).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
            self.reply.setTitle(replyStr, for: .normal)
            _ = self.reply.sd_layout().widthIs(25 + replySize.width + 20)
            let thumbStr = String(mode.thumbUP)
            let thumbSize = NSString(string: thumbStr).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
            _ = self.thumbUP.sd_layout().widthIs(25 + thumbSize.width + 20)
            self.thumbUP.setTitle(thumbStr, for: .normal)
            
            thumbUP.isSelected = mode.isLike
            collected.isSelected = mode.collected
            
            self.setupAutoHeight(withBottomView: share, bottomMargin: 10)
        }
        
    }
    
    
    private lazy var contentTitle:UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW - 40)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
        
    }()
    
    
    // 收藏
    internal lazy var  collected: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "heart")?.changesize(size: CGSize.init(width: 20, height: 20)).withRenderingMode(.alwaysTemplate), for: .normal)
        btn.setImage(UIImage.init(named: "selectedHeart")?.changesize(size: CGSize.init(width: 20, height: 20)).withRenderingMode(.alwaysTemplate), for: .selected)
        btn.clipsToBounds = true
        btn.contentHorizontalAlignment = .center
        return btn
    }()
    
    // 分享
    internal lazy var share:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "share")?.changesize(size: CGSize.init(width: 20, height: 20)).withRenderingMode(.alwaysTemplate), for: .normal)
        btn.clipsToBounds = true
        btn.contentHorizontalAlignment = .center
        //btn.tintColor = UIColor.lightGray
        return btn
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        //let views:[UIView] =  [contentTitle, userIcon, userName,createTime,contentText, lines,thumbUP, reply,share]
        let views:[UIView] = [contentTitle, share,collected]
        self.sd_addSubviews(views)
        self.subviews.forEach{
            $0.sd_clearAutoLayoutSettings()
        }
        
        
        // 重新设置约束
        _ = contentTitle.sd_layout().topSpaceToView(self,10)?.leftSpaceToView(self,10)?.autoHeightRatio(0)
        _ = userIcon.sd_layout().leftEqualToView(contentTitle)?.topSpaceToView(contentTitle,10)?.widthIs(30)?.heightIs(30)
        _ = userName.sd_layout().leftSpaceToView(userIcon,10)?.topEqualToView(userIcon)?.autoHeightRatio(0)
        _ = createTime.sd_layout().leftEqualToView(userName)?.topSpaceToView(userName,5)?.autoHeightRatio(0)
        
        _ = contentText.sd_layout().topSpaceToView(createTime,10)?.leftEqualToView(userIcon)?.rightSpaceToView(self,10)?.heightIs(0)
        _ = lines.sd_layout().topSpaceToView(contentText,15)?.leftEqualToView(contentText)?.rightEqualToView(contentText)?.heightIs(1)
        
        _ = thumbUP.sd_layout().leftEqualToView(contentText)?.topSpaceToView(contentText,20)?.widthIs(100)?.heightIs(25)
        _ = reply.sd_layout().leftSpaceToView(thumbUP,5)?.topEqualToView(thumbUP)?.heightRatioToView(thumbUP,1)?.widthRatioToView(thumbUP,1)
        _ = share.sd_layout().topEqualToView(thumbUP)?.rightSpaceToView(self,10)?.widthIs(25)?.heightRatioToView(thumbUP,1)
        _ = collected.sd_layout().topEqualToView(share)?.rightSpaceToView(share,5)?.widthIs(25)?.heightRatioToView(thumbUP,1)
        
        userIcon.sd_cornerRadiusFromWidthRatio = 0.5
        contentTitle.setMaxNumberOfLinesToShow(3)
        userName.setMaxNumberOfLinesToShow(2)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
