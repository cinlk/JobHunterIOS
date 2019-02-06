//
//  PrivacySetting.swift
//  internals
//
//  Created by ke.liang on 2018/2/23.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit




fileprivate let cellIdentity:String = "cell"
// 全局 记录总的屏蔽公司数量
var currentBlacklistCount:Int = 0


class PrivacySetting: BaseViewController {

    
    
    // popView
    
    private lazy var popCompanyView:popView = { [unowned self] in
        let v = popView.init(frame: CGRect.init(x: -200, y: (GlobalConfig.ScreenH - 100)/2 , width: 200, height: 60))
        v.layer.cornerRadius = 10
        v.layer.masksToBounds = true
        v.backgroundColor = UIColor.white
        return v
    }()
    

    
    private lazy var table:UITableView = {
        let tb = UITableView.init(frame: CGRect.zero, style: .grouped)
        tb.dataSource = self
        tb.delegate = self
        tb.backgroundColor = UIColor.viewBackColor()
        tb.tableFooterView = UIView.init()
        tb.separatorStyle = .singleLine
        tb.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentity)
        tb.register(singleButtonCell.self, forCellReuseIdentifier: singleButtonCell.identity())
        return tb
    }()
    
    
    private var currentSelected:Int?
    private var keys:[String]  = []
    
    private var mode:ResumePrivacyModel?{
        didSet{
            guard  let mode = mode else {
                return
            }
            keys  = Array(mode.listItem!.keys)
            
            for i in 0..<keys.count{
                if mode.listItem![keys[i]] == true{
                    currentSelected = i
                }
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        loadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView(UIColor.orange)
        UIApplication.shared.keyWindow?.addSubview(popCompanyView)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        popCompanyView.removeFromSuperview()
    }
    
    override func setViews(){
        self.title = "隐私设置"
        self.view.addSubview(table)
        
         _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        self.hiddenViews.append(table)
        
        super.setViews()
        
    }
    
    override func didFinishloadData(){
        
        super.didFinishloadData()
        currentBlacklistCount = mode?.companyBlacklist.count ?? 0
        
        self.table.reloadData()
    }
    
    override func showError(){
       super.showError()
    }
    
    override func reload(){
        super.reload()
        self.loadData()
        
    }
    
}

extension PrivacySetting: UITableViewDataSource, UITableViewDelegate{
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return self.mode?.listItem?.count ?? 0
        }else{
            if let row = currentSelected, keys[row] == "屏蔽指定公司"{
                return (self.mode?.companyBlacklist.count ?? 0) + 1
            }
            return 0 
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 1 && indexPath.row == self.mode?.companyBlacklist.count {
            let cell = singleButtonCell.init(style: .default, reuseIdentifier: "cell")
            cell.btnType = .add
            cell.btn.setTitle("添加屏蔽企业", for: .normal)
            cell.addMoreItem = {
                self.addCompany()
            }
            return cell
        }
            
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentity, for: indexPath)
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            cell.textLabel?.text =  keys[indexPath.row]
          
            setCellaccessView(cell: cell, selected: currentSelected == indexPath.row)
        }else{
                cell.textLabel?.text = self.mode?.companyBlacklist[indexPath.row].companyName
                addCancelBtn(cell: cell, index: indexPath)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0  && currentSelected != indexPath.row{
            // 影藏简历判断
            if keys[indexPath.row] == "影藏简历"{
                let cell = tableView.cellForRow(at: indexPath)
                cell?.presentAlert(type: .alert, title: nil, message: "隐藏简历后, 不会被推荐已经其他hr查看到你的简历", items: [actionEntity.init(title: "确认", selector: #selector(hiddenResume), args: indexPath)], target: self, complete: { alert in
                    self.present(alert, animated: true, completion: nil)
                })
            }else{
                changeCell(indexPath: indexPath)
            }
        }
        
        // 显示公司名称
        if indexPath.section  == 1{
            if let cell = tableView.cellForRow(at: indexPath), let text = cell.textLabel?.text{
                showCompanyPop(name: text)
            }
        }
    }
    
    
    
    
    
    //section
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        let label = UILabel()
        label.text = section == 0 ?  "影藏类型" : "屏蔽以下企业"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
        v.addSubview(label)
        _ = label.sd_layout().bottomSpaceToView(v,5)?.leftSpaceToView(v,TableCellOffsetX)?.autoHeightRatio(0)
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 25
        }
        if let row = currentSelected, keys[row] == "屏蔽指定公司"{
            return 10
        }
        return  0
    }
    
}


extension PrivacySetting{
    @objc private func hiddenResume(_ indexPath:IndexPath){
        changeCell(indexPath: indexPath)
    }
    
    private func changeCell(indexPath:IndexPath){
        
        self.mode?.listItem?[keys[indexPath.row]] = true
        
        currentSelected = indexPath.row
        table.reloadData()
        
    }
}

extension PrivacySetting{
    private func setCellaccessView(cell:UITableViewCell, selected:Bool){
        
        let imagev = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 25, height: 25))
        imagev.contentMode = .scaleAspectFill
        imagev.image = selected ?  #imageLiteral(resourceName: "selectedRound") :  #imageLiteral(resourceName: "round")
        cell.accessoryView  =  imagev
    }
    
    private func addCancelBtn(cell:UITableViewCell, index:IndexPath){
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        btn.setImage(#imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = UIColor.lightGray
        btn.tag = index.row
        btn.addTarget(self, action: #selector(deleteCompany), for: .touchUpInside)
        cell.accessoryView = btn
    }
    
    
    @objc private func deleteCompany(_ sender:UIButton){
        self.mode?.companyBlacklist.remove(at: sender.tag)
        currentBlacklistCount -= 1
        self.table.reloadData()
    }
    
    
    private func showCompanyPop(name:String){
        let label = UILabel()
        label.setSingleLineAutoResizeWithMaxWidth(popCompanyView.bounds.width - 10)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.text = name
        
        popCompanyView.setTitleAndView(title: "公司名称", view: label)
        let size = UILabel.sizeOfString(string: name as NSString , font: label.font, maxWidth: popCompanyView.bounds.width - 10)
        
        popCompanyView.showPop(height: size.height + 35)
       
    }
    
   
    
    private func addCompany(){
        //
        
        let addBlacklist = AddBlacklistVC()
        addBlacklist.delegate = self
        addBlacklist.hidesBottomBarWhenPushed = true
    
        self.navigationController?.pushViewController(addBlacklist , animated: true)
    }
}


extension PrivacySetting: companyBlackDelegate{
    
    func updateBlacklist(lists: [BlackistCompanyModel]) {
        guard  lists.count > 0 else { return }
        currentBlacklistCount += lists.count
        
        let lastOne = self.mode?.companyBlacklist.count ?? 0
        
        self.mode?.companyBlacklist.append(contentsOf: lists)
        
        self.table.beginUpdates()
        for i in 0..<lists.count{
            self.table.insertRows(at: [IndexPath.init(row: lastOne + i, section: 1)], with: .automatic)
        }
        self.table.endUpdates()
        
        self.table.scrollToRow(at: IndexPath.init(row:  self.mode?.companyBlacklist.count ?? 0, section: 1), at: .bottom, animated: true)
    }
}

// 这里加载
extension PrivacySetting{
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            Thread.sleep(forTimeInterval: 1)
            self?.mode = ResumePrivacyModel(JSON: ["listItem":["所有公司可见":true,"投递公司可见":false,"屏蔽指定公司":false,"影藏简历":false],"companyBlacklist":
                [
                    ["companyID":getUUID(),"companyName":"公司名称1","validate":true],
                    ["companyID":getUUID(),"companyName":"公司名称2","validate":true],
                    ["companyID":getUUID(),"companyName":"公司名称3","validate":true],
                ]
            ])
            DispatchQueue.main.async(execute: {
        
                self?.didFinishloadData()
                
            })
        }
        
        
    }
}



