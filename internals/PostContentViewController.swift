//
//  PostContentViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import MJRefresh
 
fileprivate let viewTitle:String = "帖子详情"
fileprivate let placeHolder:String = "输入评论(不能超过200字)"


class PostContentViewController: BaseViewController {

    
    private lazy var keyboardH:CGFloat = 0
    private lazy var InputViewHeigh:CGFloat = GlobalConfig.toolBarH
    private lazy var dispose: DisposeBag = DisposeBag.init()
    private lazy var vm:ForumViewModel = ForumViewModel.init()
    
    
 
    // 自己的帖子 可以删除
    internal var mypost:Bool = false
    
    private lazy var tableHeader:contentHeaderView = { [unowned self] in
        let header = contentHeaderView()
        return header
    }()
    
    // 发帖内容 header数据
    private  var headerData: PostArticleModel?
    // 回帖数据
    private  var replyModels:[FirstReplyModel] = []
    
    // 请求数据
    private var replyReq: ArticleReplyReqModel = ArticleReplyReqModel.init()
    
    //
    internal var mode:(data:PostArticleModel, row:Int)?{
        didSet{
            guard  let data = mode else {
                return
            }
            self.headerData = data.data
            //self.loadData()
            replyReq.postId = data.data.id!
            self.refreshHeader.beginRefreshing()
            
        }
    }
    
    // 来自消息界面 TODO
    internal var postID:String?{
        didSet{
            //self.loadData()
        }
    }
    

    private lazy var tableView:UITableView = { [unowned self] in
        let table = UITableView.init()
        table.rx.setDelegate(self).disposed(by: self.dispose)
        table.tableFooterView = UIView()
        table.keyboardDismissMode = .onDrag
        table.backgroundColor = UIColor.viewBackColor()
        table.register(ReplyPostTableViewCell.self, forCellReuseIdentifier: ReplyPostTableViewCell.identity())
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: GlobalConfig.toolBarH + 10, right: 0)
        return table
    }()
    // 分享view
    private lazy var shareV:ShareView = { [unowned self] in
        let share = ShareView.init(frame: CGRect.init(x: 0, y: GlobalConfig.ScreenH, width: GlobalConfig.ScreenW, height: SingletoneClass.shared.shareViewH))
        share.delegate = self
        return share
    }()
    
    
    // 底部输入框view
    private lazy var inputText:ChatInputView = { [unowned self] in
        let text = ChatInputView.init(frame: CGRect.init(x: 0, y: GlobalConfig.ScreenH - InputViewHeigh , width: GlobalConfig.ScreenW, height: InputViewHeigh))
        text.defaultText =  placeHolder
        text.plashold.text = placeHolder
        text.delegate = self
        return text
    }()
    
    
    private lazy var refreshHeader: MJRefreshHeader = {
        let h =  MJRefreshNormalHeader.init { [weak self] in
            guard let `self` = self else {
                return
            }
            
            self.replyReq.setOffset(offset:0)
            self.vm.articleReplyReq.onNext(self.replyReq)
        }
        h?.setTitle("开始刷新", for: .pulling)
        h?.setTitle("刷新中...", for: .refreshing)
        h?.setTitle("下拉刷新", for: .idle)
        h?.lastUpdatedTimeLabel.isHidden = true
        
        return h!
    }()
    
    private lazy var refreshFooter: MJRefreshFooter = {
        let f = MJRefreshAutoNormalFooter.init(refreshingBlock: {  [weak self] in
            guard let `self` = self else {
                return
            }
            self.replyReq.setOffset(offset: 10)
            self.vm.articleReplyReq.onNext(self.replyReq)
        })
        
        f?.setTitle("上拉刷新", for: .idle)
        f?.setTitle("刷新中...", for: .refreshing)
        f?.setTitle("没有数据", for: .noMoreData)
        return f!
    }()
    
    // 论坛列表父界面 删除数据
    internal var deleteSelf:((_ row: Int)->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.insertCustomerView()
        //UIApplication.shared.keyWindow?.addSubview(shareV)
        //UIApplication.shared.keyWindow?.addSubview(inputText)


    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //shareV.removeFromSuperview()
        //inputText.removeFromSuperview()
        
        
    }
    
    override func setViews() {
        
        self.title = viewTitle
        self.view.addSubview(self.tableView)
        _ = self.tableView.sd_layout()?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        self.view.addSubview(self.inputText)
        self.tableView.mj_header = refreshHeader
        self.tableView.mj_footer = refreshFooter
        self.hiddenViews.append(self.tableView)
        self.hiddenViews.append(self.inputText)
        super.setViews()
    }
    
    
    
    
    
    override func didFinishloadData() {
        super.didFinishloadData()
        
        self.tableHeader.mode = self.headerData!
        self.tableHeader.layoutSubviews()
        self.tableView.tableHeaderView = self.tableHeader
        self.mypost = headerData?.authorID == GlobalUserInfo.shared.getId()
        
        if mypost{
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "rabbish"), style: .plain, target: self, action: #selector(showAlert))
            
        }
        
       // self.tableView.reloadData()
        
    }
    
    
//    private func notFound(){
//        super.didFinishloadData()
//        self.tableView.showToast(title: "没有找找404", customImage: nil, mode: .text)
//        //showOnlyTextHub(message: "没有找找404", view: self.tableView)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.navigationController?.popvc(animated: true)
//
//        }
//    }
    
    override func reload() {
        super.reload()
        self.replyReq.setOffset(offset: 0)
        self.vm.articleReplyReq.onNext(self.replyReq)
    }

    
    
    deinit {
        print("deinit PostContentViewController \(self)")
    }
    

}



extension PostContentViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = replyModels[indexPath.row]
        return  tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: ReplyPostTableViewCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    
}

extension PostContentViewController{
    
    @objc private func showAlert(){
        
        let alert = UIAlertController.init(title: "确认删除", message: "数据将无法恢复", preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let delete = UIAlertAction.init(title: "确认", style: UIAlertAction.Style.default, handler: { [weak self] action in
            guard GlobalUserInfo.shared.isLogin else {
                return
            }
            self?.deleteThisPost()
        })
        alert.addAction(cancel)
        alert.addAction(delete)
        
        self.present(alert, animated: true, completion: nil)
    }
    
 
    
    private func deleteThisPost(){
        guard let data = self.headerData else {
            return
        }
        // 服务器删除
        self.vm.deletePostBy(postId: data.id!).asDriver(onErrorJustReturn: ResponseModel<HttpForumResponse>.init(JSON: ["result":"failed"])!).drive(onNext: { [weak self] (res) in
            guard let `self` = self else {
                return
            }
            if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                if self.mode != nil, let row = self.mode?.row{
                    self.deleteSelf?(row)
                    self.navigationController?.popvc(animated: true)
                }else if self.postID != nil{
                    if let count = self.navigationController?.viewControllers.count, count  >= 3{
                        let target = self.navigationController?.viewControllers[count - 3]
                        self.navigationController?.popToViewController(target!, animated: true)
                    }
                }
            }
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
//        // 从论坛界面操作
//        if mode != nil {
//            self.navigationController?.popvc(animated: true)
//
//            self.deleteSelf?((self.mode?.row)!)
//        }
//
//
//
//        // 从消息界面操作, 返回论坛消息
//        if postID != nil,  let count = self.navigationController?.viewControllers.count, count  >= 3 {
//            let target = self.navigationController?.viewControllers[count - 3]
//            self.navigationController?.popToViewController(target!, animated: true)
//
//        }
        
    }
}



extension PostContentViewController{
    private func setViewModel(){
        
        self.errorView.tap.drive(onNext: { [weak self]  in
            self?.reload()
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        // tableDataSource
        self.vm.articleReplyRes.share().bind(to: self.tableView.rx.items(cellIdentifier: ReplyPostTableViewCell.identity(), cellType: ReplyPostTableViewCell.self)) {
              (row, mode, cell) in
            cell.mode = mode
        }.disposed(by: self.dispose)
        
        self.tableView.rx.itemSelected.subscribe(onNext: { [weak self]  (indexPath) in

            self?.inputText.chatView.endEditing(true)
            // 跳转到子回复界面
            let vc  = SingleReplyViewController()
            vc.mode = self?.replyModels[indexPath.row]
            vc.row = indexPath.row
            vc.deleteSelf = { [weak self] row in
                guard let `self` = self else {
                    return
                }
                self.replyModels.remove(at: row)
                self.vm.articleReplyRes.accept(self.replyModels)
                //self?.tableView.reloadData()
            }
            self?.navigationController?.pushViewController(vc, animated: true)

        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)

        // header view 点击
        _ = self.tableHeader.thumbUP.rx.tap.filter({  [unowned self] in
            guard let _ = self.headerData  else {
                return false
            }
            if GlobalUserInfo.shared.isLogin{
                return true
            }else{
                self.view.showToast(title: "请登录", customImage: nil, mode: .text)
                return false
            }
        }).flatMapLatest{  [unowned self] in

            self.vm.likePost(postId: self.headerData!.id!, flag: !(self.headerData!.isLike)).asDriver(onErrorJustReturn: ResponseModel<HttpForumResponse>.init(JSON: ["result":"failed", "code":-1])!)

            }.takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self] (res) in
                guard let `self` = self else{
                    return
                }
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    self.headerData!.thumbUP =  self.headerData!.isLike ? self.headerData!.thumbUP - 1 :  self.headerData!.thumbUP + 1
                    // 显示提示
                    let title = self.headerData!.isLike ? "取消点赞" : "点赞成功"
                    self.tableHeader.thumbUP.isSelected = self.headerData!.isLike ? false :  true
                    self.tableHeader.thumbUP.setTitle(String(self.headerData!.thumbUP), for: .normal)
                    self.headerData!.isLike = !self.headerData!.isLike
                    
                   
                    self.view.showToast(title: title, customImage: nil, mode: .text)
                }else{
                    self.view.showToast(title: "失败", customImage: nil, mode: .text)
                }

            }, onError: nil, onCompleted: nil, onDisposed: nil)

       _ =  self.tableHeader.collected.rx.tap.filter { [unowned self]  in
            guard let _ = self.headerData  else {
                return false
            }
            if GlobalUserInfo.shared.isLogin{
                return true
            }else{
                self.view.showToast(title: "请登录", customImage: nil, mode: .text)
                return false
            }
            }.flatMapLatest { [unowned self] in
                self.vm.colletePost(postId: self.headerData!.id!, flag: self.headerData!.isCollected).asDriver(onErrorJustReturn: ResponseModel<HttpForumResponse>.init(JSON: ["result":"failed", "code":-1])!)
            }.takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self] (res) in
                guard let `self` = self else{
                    return
                }
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    self.tableHeader.collected.isSelected = !(self.headerData!.isCollected)
                    // 显示提示
                    let title = self.headerData!.isCollected ? "取消收藏" : "收藏成功"
                    self.headerData!.isCollected = !(self.headerData!.isCollected)
                    self.view.showToast(title: title, customImage: nil, mode: .text)
                    
                }else{

                }

            }, onError: nil, onCompleted: nil, onDisposed: nil)


        self.tableHeader.share.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.shareV.showShare()
            self?.view.endEditing(true)
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)

       _ = self.tableHeader.reply.rx.tap.asDriver().drive(onNext: { [weak self] in
            guard let `self` = self else {
                return
            }
            if self.inputText.chatView.isFirstResponder{
                self.inputText.chatView.resignFirstResponder()
                return
            }
            self.inputText.chatView.becomeFirstResponder()
        }, onCompleted: nil, onDisposed: nil)

        // 键盘
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification, object: nil).subscribe(onNext: { [weak self] (notify) in
            guard let `self` = self else{
                return
            }
            let kframe = notify.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let duration = notify.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
            let curve = notify.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber

            self.keyboardH = kframe.height

            UIView.animate(withDuration: TimeInterval(truncating: duration), delay: 0, options: [UIView.AnimationOptions.init(rawValue: UInt(truncating: curve))], animations: {

                self.inputText.frame.origin.y = GlobalConfig.ScreenH - self.keyboardH  - self.InputViewHeigh


            }, completion: nil)

        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification, object: nil).subscribe(onNext: { [weak self] (notify) in
            guard let `self` = self else{
                return
            }
            let duration = notify.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
            let curve = notify.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber
            self.keyboardH = 0

            UIView.animate(withDuration: TimeInterval(truncating: duration), delay: 0, options: [.curveEaseIn,UIView.AnimationOptions.init(rawValue: UInt(truncating: curve))], animations: {
                self.inputText.frame.origin.y = GlobalConfig.ScreenH - self.InputViewHeigh


            }, completion: nil)

        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)



        self.vm.articleReplyRes.asDriver(onErrorJustReturn: []).drive(onNext: { [weak self] (modes) in
            self?.replyModels = modes
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        // table 刷新


        self.vm.refreshReplyStatus.asDriver(onErrorJustReturn: .none).drive(onNext: { [weak self] (status) in
            guard let `self` = self else{
                return
            }

            switch status{
                case .endHeaderRefresh:
                    self.tableView.mj_footer.resetNoMoreData()
                    self.tableView.mj_header.endRefreshing()
                    self.didFinishloadData()
                case .endFooterRefresh:
                    self.tableView.mj_footer.endRefreshing()
                case .NoMoreData:
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                case .error(let error):
                    self.tableView.mj_footer.endRefreshing()
                    self.tableView.mj_header.endRefreshing()
                    self.showError()
                default:
                    break
            }

        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
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
        guard  GlobalUserInfo.shared.isLogin, let data = self.headerData  else {
            return
        }
        if let text = textView.text {
           
            // 发送给服务器
            self.vm.replyPost(postId: data.id!, content: text).asDriver(onErrorJustReturn: ResponseModel<HttpForumResponse>.init(JSON: ["result":"failed", "code":-1])!).drive(onNext: { [weak self] (res) in
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code), let uuid = res.body?.uuid{
                    if let reply = FirstReplyModel.init(JSON: [
                        "reply_id": uuid,
                        "user_icon": GlobalUserInfo.shared.getIcon()?.absoluteString,
                        "created_time": Date.init().timeIntervalSince1970,
                        "colleage":"",
                        "user_name": GlobalUserInfo.shared.getName(),
                        "like_count":0,
                        "reply_count":0,
                        "content": text,
                        "is_like": false,
                        ]){
                        self?.replyModels.append(reply)
                        self?.vm.articleReplyRes.accept(self?.replyModels ?? [])
                        // 更新 回复数据
                        self?.headerData?.reply += 1
                        self?.tableHeader.reply.setTitle("\(String(describing: (self?.headerData?.reply)!))", for: .normal)
                    }
                }
                
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
        }
        
    }
    
    
    
}

// 内容头部
fileprivate class contentHeaderView:PostHeaderView{
    
    
    internal var mode:PostBaseModel?{
        didSet{
            guard let mode = mode  else {
                return
            }
            if let url = mode.authorIcon{
                self.userIcon.kf.setImage(with: Source.network(url), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            }else{
                self.userIcon.image = #imageLiteral(resourceName: "avartar")
            }
            self.contentTitle.text = mode.title
            //self.userIcon.image = UIImage.init(named: mode.authorIcon)
            
            let authNameStr = NSMutableAttributedString.init(string: mode.authorName!, attributes: [NSAttributedString.Key.foregroundColor:UIColor.black, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
            authNameStr.append(NSAttributedString.init(string: " " + mode.colleage!, attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]))
            
            self.userName.attributedText = authNameStr
            
            self.readCount.text  =  "浏览次数 " +  String(mode.read)
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
            collected.isSelected = mode.isCollected
            
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
        
        _ = readCount.sd_layout()?.rightSpaceToView(self,20)?.topEqualToView(createTime)?.autoHeightRatio(0)
        
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
