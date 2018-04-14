//
//  JuBaoViewController.swift
//  internals
//
//  Created by ke.liang on 2017/12/21.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


fileprivate let tableFootViewH:CGFloat = 200


class JuBaoViewController: BaseViewController {

    //  举报那个job
    var jobId:String?{
        didSet{
            loadData()
        }
    }
    
    // 数据
    private var resonse:[String]?
    
    private lazy var table:UITableView = {  [unowned self] in
       var table = UITableView.init()
       table.backgroundColor = UIColor.viewBackColor()
       table.delegate = self
       table.dataSource = self
       table.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        
       return table
        
    }()
    
    private lazy var comfirm:UIButton = {  [unowned self] in
        
        let btn = UIButton.init(frame: CGRect.zero)
        btn.backgroundColor = UIColor.blue
        btn.setTitle("提交", for: .normal)
        btn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        return btn
    
    }()
    
    private let bv = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: tableFootViewH))
    
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
        v.backgroundColor = UIColor.lightGray
        let label = UILabel.init()
        label.text =  "请选择原因"
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        v.addSubview(label)
        _ = label.sd_layout().leftSpaceToView(v,10)?.topSpaceToView(v,5)?.autoHeightRatio(0)
        label.font = UIFont.systemFont(ofSize: 12)
        return v
        
    }()
   
    private var details:String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "举报界面"
        self.navigationController?.insertCustomerView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        self.navigationController?.removeCustomerView()
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
        self.view.addSubview(table)
        self.table.tableHeaderView = tableheader
        self.table.tableFooterView = bv
        
        bv.addSubview(inputField)
        bv.addSubview(comfirm)
        
        self.handleViews.append(table)
        super.setViews()
        
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
        self.table.reloadData()

    }

    
    override func reload() {
        super.reload()
        self.loadData()
    }

}


extension JuBaoViewController{
    
    private func loadData(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
         
            Thread.sleep(forTimeInterval: 3)
            // 获取数据
            DispatchQueue.main.async(execute: {
                 self?.resonse =  ["薪资不符合","职位描述不匹配","公司信息不真实","HR无法联系","工作地方不符合"]
                 self?.didFinishloadData()
                 // 错误
                 // showError()
            })
        }
       
    }
}



extension JuBaoViewController{
    @objc private func done(_ text:UITextView){
        self.inputField.endEditing(true)
    }
    
    @objc private func keyboardShow(_ notify: Notification){
        if  let keyboradFram = notify.userInfo![UIKeyboardFrameEndUserInfoKey] as? CGRect{
            
            let comfirmToTable = comfirm.convert(comfirm.origin, to: table)
            let bottonHeight = ScreenH - (comfirmToTable.y + comfirm.frame.height)
            let scrollUpHeight = keyboradFram.height - bottonHeight - NavH
            
            if scrollUpHeight > 0{
                UIView.animate(withDuration: 0.3) {
                    self.table.contentInset = UIEdgeInsetsMake(-scrollUpHeight,0, 0, 0)
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
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        return indexPath
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
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
        if let index = self.table.indexPathsForSelectedRows{
            print(index)
            self.navigationController?.popViewController(animated: true)
        }else{
            print("alert 请选择")
        }
        
    }
}
