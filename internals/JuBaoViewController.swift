//
//  JuBaoViewController.swift
//  internals
//
//  Created by ke.liang on 2017/12/21.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


fileprivate let tableFootViewH:CGFloat = 200
import RxSwift
import RxCocoa


class JuBaoViewController: BaseViewController {

    //  举报那个job
    internal var jobID:String?{
        didSet{
            self.vm.getJobWarnMessages().asDriver(onErrorJustReturn: []).drive(onNext: { (items) in
                self.resonse = items
                
            }).disposed(by: dispose)
        }
    }
    
    // 数据
    private var resonse:[String]?{
        didSet{
            self.didFinishloadData()
        }
    }
    
    private lazy var table:UITableView = {  [unowned self] in
       var table = UITableView.init()
       table.backgroundColor = UIColor.viewBackColor()
       table.delegate = self
       table.dataSource = self
        table.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
       table.tableHeaderView = tableheader
       table.tableFooterView = bv
        
       return table
        
    }()
    
    private lazy var comfirm:UIButton = {  [unowned self] in
        
        let btn = UIButton.init(frame: CGRect.zero)
        btn.backgroundColor = UIColor.blue
        btn.setTitle("提交", for: .normal)
        btn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        return btn
    
    }()
    
    private lazy var  bv:UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: tableFootViewH))
        v.addSubview(inputField)
        v.addSubview(comfirm)
        return v
    }()
    
    // 详细输入textView
    private lazy var inputField:UITextView = { [unowned self] in
        let text = UITextView()
        text.delegate = self
        
        text.font = UIFont.systemFont(ofSize: 16)
        text.keyboardType = UIKeyboardType.default
        text.inputAccessoryView =  UIToolbar.NumberkeyBoardDone(title: "完成", vc: self, selector: #selector(done(_:)))
        return text
    }()
    
    private lazy var tableheader:UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 30))
        v.backgroundColor = UIColor.clear
        let label = UILabel.init()
        label.text =  "请选择原因"
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        v.addSubview(label)
        _ = label.sd_layout().leftSpaceToView(v,10)?.topSpaceToView(v,5)?.autoHeightRatio(0)
        label.font = UIFont.systemFont(ofSize: 14)
        return v
        
    }()
   
    private var details:String = ""
    private var selectIndex:Int = -1
    
    //rxSwift
    
    let dispose = DisposeBag()
    let vm:RecruitViewModel = RecruitViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name:
            UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
  
    
    override func viewWillLayoutSubviews() {
        
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        _ = inputField.sd_layout().leftSpaceToView(bv,10)?.rightSpaceToView(bv,10)?.topSpaceToView(bv,10)?.bottomSpaceToView(comfirm,10)
        _ = comfirm.sd_layout().leftSpaceToView(bv,10)?.rightSpaceToView(bv,10)?.heightIs(25)?.bottomSpaceToView(bv,20)
        
    }
    
    
    
    override func setViews() {
        
        self.title = "举报界面"
        self.view.addSubview(table)
        
        self.handleViews.append(table)
        super.setViews()
        
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
        self.table.reloadData()

    }

    
    override func reload() {
        super.reload()
        
    }

}




extension JuBaoViewController{
    
    @objc private func done(_ text:UITextView){
        self.inputField.endEditing(true)
    }
    
    @objc private func keyboardShow(_ notify: Notification){
        if  let keyboradFram = notify.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect{
            
            let comfirmToTable = comfirm.convert(comfirm.origin, to: table)
            let bottonHeight = ScreenH - (comfirmToTable.y + comfirm.frame.height)
            let scrollUpHeight = keyboradFram.height - bottonHeight - NavH
            
            if scrollUpHeight > 0{
                UIView.animate(withDuration: 0.3) {
                    self.table.contentInset = UIEdgeInsets(top: -scrollUpHeight,left: 0, bottom: 0, right: 0)
                }
            
            }
        }
        
        
    }
    
    @objc private func keyboardHidden(_ notify: Notification){
        UIView.animate(withDuration: 0.3) {
            self.table.contentInset = UIEdgeInsets.zero
        }
        
    }
}

extension JuBaoViewController: UITextViewDelegate{
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        details = textView.text
        
    }
    
    
}

extension JuBaoViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resonse?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        if let text = resonse?[indexPath.row]{
            cell.textLabel?.text = text
            cell.textLabel?.textAlignment = .left
            cell.selectionStyle = .none
            cell.textLabel?.textColor  = selectIndex == indexPath.row ? UIColor.blue : UIColor.black
            cell.accessoryType = selectIndex == indexPath.row ? .checkmark : .none
        }
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
        label.text = "详情描述"
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
    @objc func submit(){
        
       self.inputField.endEditing(true)
       print(selectIndex,details)
        
    }
}
