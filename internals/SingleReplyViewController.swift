//
//  SingleReplyViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/13.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let viewTitle:String = "评论"

class SingleReplyViewController: UIViewController {

    
    
    // 当前回复
    private var currentSenderName:String = ""
    private var currentReceiverName:String = ""
    
    internal var mode:FirstReplyModel?{
        didSet{
            headerView.mode = mode
            currentSenderName = mode!.authorName!
            
            headerView.layoutSubviews()
            self.table.tableHeaderView = headerView
            self.loadData()
            
        }
    }
    // 子回复
    private lazy var allSubReplys:[SecondReplyModel] = []
    
    
    
    private lazy var headerView:singleHeaderView = {
        let view = singleHeaderView()
        view.thumbUP.addTarget(self, action: #selector(like), for: .touchUpInside)
        view.reply.addTarget(self, action: #selector(reply), for: .touchUpInside)
        
        return view
    }()
    
    
    private lazy var table:UITableView = { [unowned self] in
        let tb = UITableView()
        tb.tableFooterView = UIView()
        tb.backgroundColor = UIColor.viewBackColor()
        tb.dataSource = self
        tb.delegate = self
        tb.register(contentCell.self, forCellReuseIdentifier: contentCell.identity())
        
        return tb
    }()
    
    // 状态进度
    private lazy var  progressView:UIActivityIndicatorView = {
       let pv = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        pv.center = CGPoint.init(x: ScreenW/2, y: ScreenH/2)
        pv.color = UIColor.orange
        pv.hidesWhenStopped = true
        return pv
    }()
    
    
    private lazy var alertVC:UIAlertController = {
        let vc = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let report = UIAlertAction.init(title: "举报", style: UIAlertActionStyle.default, handler:{ action in
            print("action")
        })
        vc.addAction(report)
        vc.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        
        
        return vc
    }()
    
    
    // 底部按钮
    private lazy var replyBtn:UIButton = {   [unowned self] in
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x: 0, y: 0, width: 100, height: TOOLBARH)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.addTarget(self, action: #selector(reply), for: .touchUpInside)
        btn.tintColor = UIColor.blue
        // 调整image在上 title 在下
        btn.setPositionWith(image: #imageLiteral(resourceName: "comment").changesize(size: CGSize.init(width: 20, height: 20)).withRenderingMode(.alwaysTemplate), title: "回复", titlePosition: .bottom, additionalSpacing: 5, state: .normal, offsetY: -10)
        
        return btn
        
    }()
    
    private lazy var likeBtn:UIButton = {  [unowned self] in
        let btn = UIButton.init(type: .custom)
        btn.frame = replyBtn.frame
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setPositionWith(image: UIImage.init(named: "thumbup")?.changesize(size: CGSize.init(width: 20, height: 20)).withRenderingMode(.alwaysTemplate), title: "点赞", titlePosition: .bottom, additionalSpacing: 5, state: .normal, offsetY: -10)
        
        btn.tintColor = UIColor.blue
        btn.addTarget(self, action: #selector(like), for: .touchUpInside)
        return btn
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView()
        self.navigationItem.title = viewTitle
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.removeCustomerView()
        self.navigationItem.title = ""
        self.navigationController?.setToolbarHidden(true, animated: true)

        
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
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: contentCell.self, contentViewWidth: ScreenW)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let mode = allSubReplys[indexPath.row]
        currentReceiverName = mode.sender!
        
        let commentVC = PostCommentViewController()
        commentVC.title = "回复\(mode.sender!)"
        commentVC.postBack = { content in
    
            self.addNewMessage(content)
        }
        self.present(commentVC, animated: true, completion: nil)
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
    private func setViews(){
        self.view.addSubview(table)
        self.table.addSubview(progressView)
        
        // 添加navBtn
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "more")?.changesize(size: CGSize.init(width: 20, height: 20)).withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(warn))
        
        
        self.toolbarItems = [UIBarButtonItem.init(customView: replyBtn)]
        let fixSpace = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixSpace.width = ScreenW - 2*100
        self.toolbarItems?.append(fixSpace)
        // 点赞
        self.toolbarItems?.append(UIBarButtonItem.init(customView: likeBtn))
        
       
        
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
    }
    
    private func didFinishLoad(){
        progressView.stopAnimating()
        self.table.reloadData()
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
            likeBtn.tintColor = UIColor.blue
            return
            
        }
        // 上传到服务器
        likeBtn.tintColor = UIColor.red
        mode?.isLike = true
        mode?.thumbUP += 1
        headerView.thumbUP.setTitle(String(mode!.thumbUP), for: .normal)
        //tableHeader.thumbUP.isSelected = true
        headerView.thumbUP.tintColor = UIColor.blue
    }
    
    @objc private func reply(){
        let commentVC = PostCommentViewController()
        commentVC.title = "回复\(mode!.authorName!)"
        currentReceiverName = (mode?.authorName)!
        
        commentVC.postBack = { content in
            self.addNewMessage(content)
        }
        
        self.present(commentVC, animated: true, completion: nil)
        
    }
    
    
    @objc private func warn(){
        self.present(alertVC, animated: true, completion: nil)

    }
    
}

// 获取数据
extension SingleReplyViewController{
    private func loadData(){
        
        progressView.startAnimating()
        DispatchQueue.global(qos: .userInitiated).async {  [weak self] in
            
            Thread.sleep(forTimeInterval: 3)
            for _ in 0..<6{
                self?.allSubReplys.append(SecondReplyModel(JSON: ["parentReplyID":"dqwd-dqw-dqwd","sender":"小红","receiver":"佩奇","content":"我看你才是🐽"])!)
                
            }
            for _ in 0..<5{
                self?.allSubReplys.append(SecondReplyModel(JSON: ["parentReplyID":"dqwd-dqw-dqwd","sender":"楼主","receiver":"小红","content":"啥子喔当前为多群 当前为多群多群多群无多  \n 当前为多群当前为多群无-dqwd当前为多群多"])!)
            }
            
            
            DispatchQueue.main.async(execute: {
                self?.didFinishLoad()
                
                // 错误处理！！！
            })
        }
    }
}


extension SingleReplyViewController:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //self.inputText.chatView.endEditing(true)
    }
    
    func addNewMessage(_ content:String){
        
        if !content.trimmingCharacters(in: CharacterSet.init(charactersIn: " \n")).isEmpty{
            let message = SecondReplyModel(JSON: ["parentReplyID":"dwqd-dqwdq","sender":self.currentSenderName,
                                                  "content":content,"receiver":self.currentReceiverName])!
            self.allSubReplys.append(message)
            self.table.reloadData()
            
        }
    }
}



fileprivate class  singleHeaderView:PostHeaderView{
 
    
    internal var mode:FirstReplyModel?{
        didSet{
            guard  let mode = mode  else {
                return
            }
            self.userName.text = mode.authorName
            self.userIcon.image = UIImage.init(named: mode.authorIcon)
            self.createTime.text = mode.createTimeStr
            self.contentText.text = mode.replyContent
            
            // 计算contentText高度
            let contentSize = self.contentText.sizeThatFits(CGSize.init(width: ScreenW, height: CGFloat(MAXFLOAT))
            )
            _ = self.contentText.sd_layout().heightIs(contentSize.height)
            
            // 更加数字长度 调整btn长度
            let replyStr = String(mode.reply)
            let replySize = NSString(string: replyStr).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)])
            self.reply.setTitle(replyStr, for: .normal)
            _ = self.reply.sd_layout().widthIs(25 + replySize.width + 20)
            let thumbStr = String(mode.thumbUP)
            let thumbSize = NSString(string: thumbStr).size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)])
            _ = self.thumbUP.sd_layout().widthIs(25 + thumbSize.width + 20)
            self.thumbUP.setTitle(thumbStr, for: .normal)
            
            
            
            
            self.setupAutoHeight(withBottomView: self.thumbUP, bottomMargin: 10)
            
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// cell
@objcMembers fileprivate class contentCell:UITableViewCell{
    
    
   
    private lazy var content:UILabel = {
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        
        return label
    }()
    
    
    dynamic internal var mode:SecondReplyModel?{
        didSet{
            guard let mode = mode else {
                return
            }
            let sender = NSMutableAttributedString.init(string: mode.sender!)
            sender.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.blue], range: NSRange.init(location: 0, length: mode.sender!.count))
            
            let talkto = NSAttributedString.init(string: " 回复 ")
            let receiver = NSMutableAttributedString.init(string: mode.receiver!)
            receiver.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.blue], range: NSRange.init(location: 0, length: mode.receiver!.count))
            receiver.append(NSAttributedString.init(string: ": "))
            
            let content = NSMutableAttributedString.init(string: mode.content!)
            
            
            
            let attrStr = NSMutableAttributedString.init()
            attrStr.append(sender)
            attrStr.append(talkto)
            attrStr.append(receiver)
            attrStr.append(content)
            self.content.attributedText = attrStr
            self.setupAutoHeight(withBottomView: self.content, bottomMargin: 10)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(content)
        _ = content.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,10)?.autoHeightRatio(0)
        content.setMaxNumberOfLinesToShow(0)
        
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "contentCell"
    }
    
}
