//
//  JuBaoViewController.swift
//  internals
//
//  Created by ke.liang on 2017/12/21.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


import RxSwift
import RxCocoa



fileprivate let tableFootViewH:CGFloat = 200
fileprivate let viewTitle:String = "举报界面"
fileprivate let TOTAL_NUM:Int = 200




private class  tableFootView:UIView{
    
    private weak var vc:JuBaoViewController?
    
    
    internal lazy var comfirm:UIButton = {  [unowned self] in
        
        let btn = UIButton.init(frame: CGRect.zero)
        btn.backgroundColor = UIColor.blue
        btn.setTitle("提交", for: .normal)
        btn.addTarget(self.vc!, action: #selector(self.vc!.submit), for: .touchUpInside)
        return btn
        
    }()
    
    // 详细输入textView
    internal lazy var inputField:UITextView = { [unowned self] in
        let text = UITextView()
        text.delegate = self.vc!
        text.font = UIFont.systemFont(ofSize: 16)
        text.keyboardType = UIKeyboardType.default
        text.inputAccessoryView =  UIToolbar.NumberkeyBoardDone(title: "完成", vc: self.vc!, selector: #selector(self.vc!.done(_:)))
        
        return text
    }()
    
    
    convenience init(frame:CGRect, vc:JuBaoViewController){
        self.init(frame: frame)
        self.vc = vc
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(inputField)
        self.addSubview(comfirm)
        
        _ = inputField.sd_layout().leftSpaceToView(self,10)?.rightSpaceToView(self,10)?.topSpaceToView(self,10)?.bottomSpaceToView(comfirm,10)
        _ = comfirm.sd_layout().leftSpaceToView(self,10)?.rightSpaceToView(self,10)?.heightIs(25)?.bottomSpaceToView(self,20)
        
    }
    
    
}


class JuBaoViewController: UIViewController {


    
    private lazy var jvm: RecruitViewModel = RecruitViewModel.init()
    private lazy var fvm: ForumViewModel = ForumViewModel.init()
    
    private var type:JuBaoType = .job
    private var id:String = ""
        
    private var reason:String = ""
    private var selectIndex:Int = -1
    
    private var resonse:[String] = []
    private lazy var dispose:DisposeBag = DisposeBag.init()
    
    private lazy var table:UITableView = {  [unowned self] in
        
        // header
        let tableheader = UIView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: 30))
        tableheader.backgroundColor = UIColor.clear
        let label = UILabel.init()
        label.text =  "请选择原因"
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
        tableheader.addSubview(label)
        _ = label.sd_layout().leftSpaceToView(tableheader,10)?.topSpaceToView(tableheader,5)?.autoHeightRatio(0)
        label.font = UIFont.systemFont(ofSize: 14)
            
   
        
       var table = UITableView.init()
       table.backgroundColor = UIColor.viewBackColor()
       table.delegate = self
       table.dataSource = self
       table.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
       table.tableHeaderView = tableheader
       tableFooter.layoutSubviews()
       table.tableFooterView = tableFooter
        
       return table
        
    }()
    
   
    
    private lazy var  tableFooter:tableFootView = { [unowned self] in
        let v = tableFootView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: tableFootViewH), vc: self)
        return v
    }()
    
   

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    convenience init(type: JuBaoType, id:String){
        self.init(nibName: nil, bundle: nil)
        self.type = type
        self.id = id
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.setViewModel()
        self.loadData()
    }
    
    deinit {
        print("deinit jubaoVC \(String.init(describing: self))")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
    }
    
    private func setViews() {
    
        self.title = viewTitle
        self.view.addSubview(table)
    }
    
    private func loadData(){
        switch self.type {
            case .job:
                self.resonse = SingletoneClass.shared.jobWarns
            case .forum, .reply, .subReply:
                 self.resonse = SingletoneClass.shared.forumWans
        }
        
        self.table.reloadData()
    }

}




extension JuBaoViewController{
    
    private func setViewModel(){
    _ = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification).takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self] (notify) in
            guard let `self` = self else{
                return
            }
            if  let keyboradFram = notify.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect{
                
                //  table 上移距离计算
                let comfirmToTable = self.tableFooter.comfirm.convert(self.tableFooter.comfirm.origin, to: self.table)
                let bottonHeight = GlobalConfig.ScreenH - (comfirmToTable.y + self.tableFooter.comfirm.frame.height)
                let scrollUpHeight = keyboradFram.height - bottonHeight - GlobalConfig.NavH
                
                if scrollUpHeight > 0{
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        self?.table.contentInset = UIEdgeInsets(top: -scrollUpHeight,left: 0, bottom: 0, right: 0)
                    }
                    
                }
            }
        })
        
        _ = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self]  (notify) in
                UIView.animate(withDuration: 0.3) { [weak self]  in
                    self?.table.contentInset = UIEdgeInsets.zero
                }
            })
    }
    
    @objc internal func done(_ text:UITextView){
        self.tableFooter.inputField.endEditing(true)
    }
    

}

extension JuBaoViewController: UITextViewDelegate{
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        reason = textView.text
        
    }
    
    // 限制字数 TODO
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count > 150 {
            
            //获得已输出字数与正输入字母数
            let selectRange = textView.markedTextRange
            
            //获取高亮部分
            if let selectRange = selectRange {
                let position =  textView.position(from: (selectRange.start), offset: 0)
                if (position != nil) {
                    return
                }
            }
            
            let textContent = textView.text
            let textNum = textContent?.count
            
            //截取200个字
            if textNum ?? 0 > TOTAL_NUM {
                if let index = textContent?.index(textContent!.startIndex, offsetBy: TOTAL_NUM){
                    let str = textContent![..<index]
                    textView.text = String.init(str)
                }
              
                //let str = textContent?.substring(to: index!)
              
            }
        }
        
    }
}

extension JuBaoViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resonse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        let text = resonse[indexPath.row]
        cell.textLabel?.text = text
        cell.textLabel?.textAlignment = .left
        cell.selectionStyle = .none
        cell.textLabel?.textColor  = selectIndex == indexPath.row ? UIColor.blue : UIColor.black
        cell.accessoryType = selectIndex == indexPath.row ? .checkmark : .none
    
        return cell
    }
    
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selectIndex = indexPath.row
        tableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        
        let label = UILabel.init(frame: CGRect.zero)
        label.text = "详情描述(200字以内)"
        label.font = UIFont.systemFont(ofSize: 14)
        label.setSingleLineAutoResizeWithMaxWidth(200)
        v.addSubview(label)
        _ = label.sd_layout().leftSpaceToView(v,TableCellOffsetX)?.topSpaceToView(v,2.5)?.autoHeightRatio(0)
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  20
    }
    
}

extension JuBaoViewController{
    
    @objc internal func submit(){
       self.tableFooter.inputField.endEditing(true)
       print(selectIndex,reason)
        let content = selectIndex >= 0 ? self.resonse[selectIndex] : reason
       // 提交到服务器 TODO
        switch self.type {
        case .job:
            jvm.jubao()
        case .forum:
            fvm.alertPost(postId: self.id, content: content).subscribe(onNext: { (res) in
                // TODO
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        case .reply:
            fvm.alertReply(replyId: self.id, content: content).subscribe(onNext: { (res) in
                // TODO
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        case .subReply:
            fvm.alertSubReply(subReplyId: self.id, content: content).subscribe(onNext: { (res) in
                // TODO
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        }
       self.navigationController?.popvc(animated: true)
        
    }
}
