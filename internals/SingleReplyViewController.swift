//
//  SingleReplyViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/13.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MJRefresh
import Kingfisher

fileprivate let viewTitle:String = "回帖"

class SingleReplyViewController: BaseViewController {

    private lazy var keyboardH:CGFloat = 0
    private lazy var InputViewHeigh:CGFloat = GlobalConfig.toolBarH
    private lazy var vm: ForumViewModel = ForumViewModel.init()
    private lazy var dispose:DisposeBag = DisposeBag.init()
    private lazy var req: SubReplyReqModel = SubReplyReqModel.init()
    private lazy var talkedUserId:String = ""
    
    
    // 回调父界面 删除数据
    internal var deleteSelf:((_ row: Int)->())?
    
    private var row:Int = -1
    
    private var myReply:Bool = false
    
    // 自己的回贴 可以删除
   // internal var mycomment:Bool = false
    //
    internal var currentSenderName:String = ""{
        didSet{
            self.resetPlashold(name: self.currentSenderName)
        }
    }
    //private var currentSelecteCell:Int = -1
    
    
    // 子评论id
    //internal var subReplyID:String?
    
    // MARK 上拉刷新 获取回帖内容 和 回复内容, 忽略是回帖 还是自子评论 ！！！
    // 子评论 不能下拉刷新
    // 都可以发布评论
    
    private var mode:FirstReplyModel? //{
//        didSet{
//            //mycomment = mode?. ==  GlobalUserInfo.shared.getId()
//            headerView.mode = mode
//            currentSenderName = mode!.userName!
//            headerView.layoutSubviews()
//            self.table.tableHeaderView = headerView
//
//            //loadData()
//        }
//    }
    
    // 子回复
    private lazy var allSubReplys:[SecondReplyModel] = []
    

    private lazy var headerView:singleHeaderView = { [unowned self] in
        let view = singleHeaderView()
//        view.thumbUP.addTarget(self, action: #selector(like), for: .touchUpInside)
//        view.reply.addTarget(self, action: #selector(reply), for: .touchUpInside)
//
        return view
    }()
    
    
    private lazy var table:UITableView = { [unowned self] in
        let tb = UITableView()
        tb.tableFooterView = UIView()
        tb.backgroundColor = UIColor.viewBackColor()
        //tb.dataSource = self
        tb.rx.setDelegate(self).disposed(by: self.dispose)
        //tb.delegate = self
        tb.keyboardDismissMode = .onDrag
        tb.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: InputViewHeigh + 10, right: 0)
        tb.register(contentCell.self, forCellReuseIdentifier: contentCell.identity())
        
        return tb
    }()
    
    // 回复数据加载 状态进度
//    internal lazy var  progressView:UIActivityIndicatorView = {
//        let pv = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.whiteLarge)
//        pv.center = CGPoint.init(x: GlobalConfig.ScreenW/2, y: GlobalConfig.ScreenH/2)
//        pv.color = UIColor.orange
//        pv.hidesWhenStopped = true
//        return pv
//    }()
    
    
    private lazy var refreshHeader: MJRefreshNormalHeader =  {
        let h = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            guard let `self` = self else {
                return
            }
            self.req.setOffset(offset:0)
            self.vm.subReplyReq.onNext(self.req)
        })
        
        h?.setTitle("开始刷新", for: .pulling)
        h?.setTitle("刷新中...", for: .refreshing)
        h?.setTitle("下拉刷新", for: .idle)
        h?.lastUpdatedTimeLabel.isHidden = true
        return h!
    }()
    
    
    private lazy var refreshFooter: MJRefreshAutoNormalFooter = {
        let f = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            guard let `self` = self else {
                return
            }
            self.req.setOffset(offset:10)
            self.vm.subReplyReq.onNext(self.req)
            
        })
        
        f?.setTitle("上拉刷新", for: .idle)
        f?.setTitle("刷新中...", for: .refreshing)
        f?.setTitle("没有数据", for: .noMoreData)
        return f!
    }()
  
  
    
    // 底部输入框view
    private lazy var inputText:ChatInputView = { [unowned self] in
        let text = ChatInputView.init(frame: CGRect.init(x: 0, y: GlobalConfig.ScreenH - InputViewHeigh , width: GlobalConfig.ScreenW, height: InputViewHeigh))
        //text.plashold.text = "回复\(currentSenderName)"
        text.delegate = self
        return text
    }()

    // 更多btn
    private lazy var moreBtn:UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = UIColor.clear
        btn.setImage(#imageLiteral(resourceName: "more").changesize(size: CGSize.init(width: 30, height: 15), renderMode: .alwaysTemplate), for: .normal)
        return btn
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(data: FirstReplyModel, row:Int){
        self.init(nibName: nil, bundle: nil)
        self.mode = data
        self.row = row
        self.req.replyId = data.replyID!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setViews()
        setViewModel()
        
        self.table.mj_header = refreshHeader
        self.table.mj_footer = refreshFooter
        refreshHeader.beginRefreshing()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.insertCustomerView()
        //self.navigationItem.title = viewTitle
        //UIApplication.shared.keyWindow?.addSubview(inputText)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.removeCustomerView()
       // self.navigationItem.title = ""
       // inputText.removeFromSuperview()
    }

    
    override func setViews(){

        self.title = viewTitle
        
        self.view.addSubview(table)
        //self.table.addSubview(progressView)
        
        self.view.addSubview(inputText)
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
        self.hiddenViews.append(table)
        self.hiddenViews.append(inputText)
        
        self.myReply = self.mode?.userId == GlobalUserInfo.shared.getId()
       
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: moreBtn)
        
        
        
        super.setViews()
        
        
    }
    
    override func didFinishloadData(){
        super.didFinishloadData()
        //progressView.stopAnimating()
        headerView.mode = mode
        currentSenderName = mode!.userName!
        headerView.layoutSubviews()
        self.table.tableHeaderView = headerView
        // 默认回复楼主
        self.talkedUserId = (mode?.userId)!
        
        
    }
    
    override  func reload() {
        super.reload()
        //self.loadData()
        self.req.setOffset(offset: 0)
        self.vm.subReplyReq.onNext(self.req)
    }
    
    deinit {
        print("deinit SingleViewController \(self)")
    }

    
    
}


extension SingleReplyViewController{
    
    private func setViewModel(){
        
        
        self.errorView.tap.drive(onNext: { [weak self]  in
            self?.reload()
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        self.moreBtn.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.showAlert()
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
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
                
            }, completion: { bool in
                //self.currentSelecteCell = -1
                //self.resetPlashold(name: self.mode!.userName!)
                self.currentSenderName = self.mode!.userName!
                self.talkedUserId = (self.mode?.userId)!
                
            })
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        // headerview
        self.headerView.thumbUP.rx.tap.filter({  [weak self] in
            if GlobalUserInfo.shared.isLogin == false {
                self?.view.showToast(title: "请登录", customImage: nil, mode: .text)
                return false
            }
            return true
        }).flatMapLatest({ [unowned self] in
            
            self.vm.likeReply(replyId: self.mode!.replyID!, flag: !(self.mode!.isLike))
        }).subscribe(onNext: { [weak self] (req) in
            
            guard let `self` = self else{
                return
            }
        
            guard let mode = self.mode, let code = req.code, HttpCodeRange.filterSuccessResponse(target: code) else {
                return
            }
            
            let title:String = mode.isLike ? "取消点赞" : "点赞成功"
            self.mode?.likeCount =  mode.isLike ? mode.likeCount - 1 :  mode.likeCount + 1
            self.headerView.thumbUP.setTitle(String(mode.likeCount), for: .normal)
            self.headerView.thumbUP.tintColor = mode.isLike ? UIColor.lightGray: UIColor.blue
            self.view.showToast(title: title, customImage: nil, mode: .text)
            self.mode?.isLike = !mode.isLike
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
//        self.headerView.reply.rx.tap.asDriver().drive(onNext: { [weak self] in
//            guard let `self` = self else {
//                return
//            }
//
//
//        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
//
        
        
        // table
        
        self.vm.subReplyRes.asDriver(onErrorJustReturn: []).drive(onNext: { [weak self] (modes) in
            self?.allSubReplys = modes
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        self.vm.subReplyRes.share().bind(to: self.table.rx.items(cellIdentifier: contentCell.identity(), cellType: contentCell.self)){
            (row, mode, cell) in
            cell.mode = mode
        }.disposed(by: self.dispose)
        
        self.table.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            
            self?.table.deselectRow(at: indexPath, animated: true)
            self?.inputText.chatView.endEditing(true)
            //currentReceiverName = mode.authorName!
            //self?.currentSelecteCell = indexPath.row
            // TODO
            //        if  allSubReplys[indexPath.row].authorID == GlobalUserInfo.shared.getId() {
            //            buildAlert(showDelete: true)
            //        }
            self?.buildAlert(row: indexPath.row)
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        // 刷新
        self.vm.refreshSubReplyStatus.asDriver(onErrorJustReturn: .none).drive(onNext: { [weak self] (status) in
            guard let `self` = self else {
                return
            }
            switch status{
                case .endHeaderRefresh:
                    self.table.mj_footer.resetNoMoreData()
                    self.table.mj_header.endRefreshing()
                    self.didFinishloadData()
                
                case .endFooterRefresh:
                    self.table.mj_footer.endRefreshing()
                
                case .NoMoreData:
                    self.table.mj_footer.endRefreshingWithNoMoreData()
                case .error(let err):
                    self.table.mj_header.endRefreshing()
                    self.table.mj_footer.endRefreshing()
                    self.showError()
                default:
                    break
            }
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
    }
}

// table

extension SingleReplyViewController:  UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = allSubReplys[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: contentCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
    }
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        self.inputText.chatView.endEditing(true)
//        //currentReceiverName = mode.authorName!
//        currentSelecteCell = indexPath.row
//        // TODO
////        if  allSubReplys[indexPath.row].authorID == GlobalUserInfo.shared.getId() {
////            buildAlert(showDelete: true)
////        }
//        buildAlert(showDelete: false)
//
//
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    
    
}






extension SingleReplyViewController{
    
    private func buildAlert(row:Int){
        
        // 验证用户登录？？
        
        let vc = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let like = self.allSubReplys[row].isLike
        let title =  like ? "取消赞" : "赞"
        let thumbUP = UIAlertAction.init(title: title, style: UIAlertAction.Style.default, handler: { [weak self] action in
            guard let `self` = self else{
                return
            }
            if let sid = self.allSubReplys[row].secondReplyId{
                
                
                self.vm.likeSubReply(subReplyId: sid, flag: !like).subscribe(onNext: { (res) in
                    if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                        self.allSubReplys[row].likeCount = like ?  self.allSubReplys[row].likeCount - 1 : self.allSubReplys[row].likeCount + 1
                        self.allSubReplys[row].isLike = !like
                        
                        self.vm.subReplyRes.accept(self.allSubReplys)
                    }
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            }
            
        })
        
        let comment = UIAlertAction.init(title: "评论", style: .default, handler: { [weak self]  action in
            guard let `self` = self else{
                return
            }
            let name  = self.allSubReplys[row].userName!
            
            self.talkedUserId =  self.allSubReplys[row].userId!
            
            self.currentSenderName = name
            //self.resetPlashold(name: name)
            
            self.inputText.chatView.becomeFirstResponder()
        })
        
        // 举报
        let jubao = UIAlertAction.init(title: "举报", style: .default) { [weak self] (action) in
            guard let `self` = self else{
                return
            }
            if let sid = self.allSubReplys[row].secondReplyId{
                let vc = JuBaoViewController.init(type: .subReply, id: sid)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        // 自己的评论
        let delete = UIAlertAction.init(title: "删除", style: UIAlertAction.Style.destructive, handler: { [weak self] action in
            guard let `self` = self else{
                return
            }
            // 服务器端删除
            if let sid = self.allSubReplys[row].secondReplyId{
                self.vm.deleteSubReply(subReplyId: sid).subscribe(onNext: { [weak self] (res) in
                    guard let `self` = self else {
                        return
                    }
                    self.allSubReplys.remove(at: row)
                    self.vm.subReplyRes.accept(self.allSubReplys)
                    
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            }

        })
        
        
        vc.addAction(thumbUP)
        vc.addAction(comment)
        vc.addAction(jubao)
        if  self.allSubReplys[row].userId == GlobalUserInfo.shared.getId(){
            vc.addAction(delete)
        }
        vc.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    private func resetPlashold(name:String){
        //self.currentSenderName = name
        if self.inputText.chatView.text.isEmpty{
            self.inputText.plashold.text = "回复\(name)"
        }
    }

    
    @objc private func showAlert(){
        
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let delete = UIAlertAction.init(title: "删除", style: UIAlertAction.Style.destructive, handler: {   [unowned self]   action in
            self.deleteMyself()
        })
        let jubao = UIAlertAction.init(title: "举报", style: .default) { [weak self] action in
            
            guard let `self` = self else{
                return
            }
            self.inputText.endEditing(true)
            let vc = JuBaoViewController.init(type: .reply, id: (self.mode?.replyID)!)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        let reply = UIAlertAction.init(title: "回复", style: .default) { [weak self] (action) in
            guard let `self` = self else{
                return
            }
            self.reply(name: (self.mode?.userName)!, id: (self.mode?.userId)!)
        }
        
        alert.addAction(reply)
        alert.addAction(jubao)
        alert.addAction(cancel)
        if self.myReply{
            alert.addAction(delete)
        }
        
        self.present(alert, animated: true, completion: nil)

    }
    
    
    private func deleteMyself(){
        
        self.vm.deleteReply(replyId: self.mode!.replyID!).subscribe(onNext: { [weak self] (res) in
            guard let `self` = self else {
                return
            }
            if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                
                self.navigationController?.popvc(animated: true)
                self.deleteSelf?(self.row)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
    }
    
    
    private func reply(name:String, id:String){
        
        if self.inputText.chatView.isFirstResponder {
            self.inputText.chatView.resignFirstResponder()
            return
        }
        self.inputText.chatView.becomeFirstResponder()
        self.currentSenderName = name
        //self.resetPlashold(name: self.mode!.userName!)
        self.talkedUserId = id
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
        
        guard  GlobalUserInfo.shared.isLogin, let mode = self.mode else {
            return
        }
        
        if let text = textView.text{
            self.vm.postSubReply(replyId: mode.replyID!, talkedUserId: self.talkedUserId, content: text).subscribe(onNext: { [weak self] (res) in
                guard let `self` = self else {
                    return
                }
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code), let sid = res.body?.uuid{
                    if let m = SecondReplyModel.init(JSON: [
                        "reply_id": self.mode?.replyID!,
                        "second_reply_id": sid,
                        "content": text,
                        "is_like": false,
                        "created_time": Date.init().timeIntervalSince1970,
                        "like_count":0,
                        "user_id": GlobalUserInfo.shared.getId()!,
                        "user_icon": GlobalUserInfo.shared.getIcon()?.absoluteString,
                        "user_name": GlobalUserInfo.shared.getName()!,
                        "talked_user_name": self.currentSenderName,
                        "talked_user_id": self.talkedUserId,
                        "to_host": self.talkedUserId == self.mode?.userId!
                        ]){
                        self.allSubReplys.append(m)
                        self.vm.subReplyRes.accept(self.allSubReplys)
                        // 更新个数
                        self.mode?.replyCount += 1
                        self.headerView.reply.setTitle(String(self.mode?.replyCount ?? 0 ), for: .normal)
                    }
                    
                }else{
                    self.view.showToast(title: "回复失败", customImage: nil, mode: .text)
                }
                
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        }
    }
    
    
}




fileprivate class  singleHeaderView:PostHeaderView{
 
    
    internal var mode:FirstReplyModel?{
        didSet{
            guard  let mode = mode  else {
                return
            }
            if let url = mode.userIcon{
              self.userIcon.kf.indicatorType = .activity
              self.userIcon.kf.setImage(with: Source.network(url), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            self.userName.text = mode.userName
            //self.userIcon.image = UIImage.init(named: mode.authorIcon)
            self.createTime.text = mode.createdTimeStr
            self.contentText.text = mode.content
            
            // 计算contentText高度
            let contentSize = self.contentText.sizeThatFits(CGSize.init(width: GlobalConfig.ScreenW, height: CGFloat(MAXFLOAT))
            )
            _ = self.contentText.sd_layout().heightIs(contentSize.height)
            
            // 更加数字长度 调整btn长度
            let replyStr = String(mode.replyCount)
            let replySize = NSString(string: replyStr).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
            self.reply.setTitle(replyStr, for: .normal)
            // 25 是image 的长度
            _ = self.reply.sd_layout().widthIs(25 + replySize.width)
            let thumbStr = String(mode.likeCount)
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
        readCount.isHidden = true
        _ = thumbUP.sd_layout().rightSpaceToView(self,10)?.topEqualToView(userName)?.widthIs(0)?.heightIs(25)
        _ = reply.sd_layout().rightSpaceToView(thumbUP,0)?.topEqualToView(thumbUP)?.heightRatioToView(thumbUP,1)?.widthIs(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// cell
@objcMembers fileprivate class contentCell:ForumBaseCell{
    
    dynamic internal var mode:SecondReplyModel?{
        didSet{
            guard let mode = mode else {
                return
            }
         
            if let url = mode.userIcon{
                self.authorIcon.kf.indicatorType = .activity
                self.authorIcon.kf.setImage(with: Source.network(url), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            self.creatTime.text = mode.createdTimeStr
            //self.authorIcon.image = UIImage.init(named: mode.authorIcon)
            self.postType.text = ""
            
            let authNameStr = NSMutableAttributedString.init(string: mode.userName!, attributes: [NSAttributedString.Key.foregroundColor:UIColor.black, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)])
//            authNameStr.append(NSAttributedString.init(string: " " + mode.colleage!, attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)]))
            
            self.authorName.attributedText = authNameStr
            
            
            
            let talkto = NSAttributedString.init(string: " 回复 ")
            let receiver = NSMutableAttributedString.init(string: mode.talkedUserName!)
            receiver.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue], range: NSRange.init(location: 0, length: mode.talkedUserName!.count))
            receiver.append(NSAttributedString.init(string: ": "))
            
            let content = NSMutableAttributedString.init(string: mode.content!)
            
            
            
            let attrStr = NSMutableAttributedString.init()
            if !mode.toHost{
                attrStr.append(talkto)
                attrStr.append(receiver)
            }
            
            attrStr.append(content)
            self.postTitle.attributedText = attrStr
            
            
            
            // 点赞
            let ts = String(mode.likeCount)
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
