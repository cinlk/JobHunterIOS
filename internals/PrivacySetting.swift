//
//  PrivacySetting.swift
//  internals
//
//  Created by ke.liang on 2018/2/23.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit



fileprivate let headerViewH:CGFloat = 50
fileprivate let headerTitle:String = "简历隐私设置"
fileprivate let status:[String] = ["所有公司可见","只有投递公司可见","屏蔽指定公司","影藏简历"]

class PrivacySetting: UITableViewController {

    private var currentSelectedRow:Int = 0
    
    private lazy var headerView:UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: headerViewH))
        v.backgroundColor = UIColor.white
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.text = headerTitle
        label.textColor = UIColor.black
        label.sizeToFit()
        v.addSubview(label)
        
        _ = label.sd_layout().leftSpaceToView(v,TableCellOffsetX)?.bottomSpaceToView(v,10)?.rightSpaceToView(v,20)
        
        return v
        
    }()
    
    // 由于tableview reloadindex 有bug，加入moreCell 指向
    // 屏蔽公司的cell
    private var moreCell:PrivacyCellView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 获取数据 刷新table
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "隐私设置"
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationItem.title = ""
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return status.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: PrivacyCellView.identity(), for: indexPath) as?
            PrivacyCellView
        cell?.delegate = self
        
        if cell == nil{
            cell = PrivacyCellView.init(style: .default, reuseIdentifier: PrivacyCellView.identity())
        }
        let mode = privacyModel(title: status[indexPath.row], selected: false, showCompany:false)
        if currentSelectedRow == indexPath.row{
            mode.selected = true
            if currentSelectedRow == 2{
                mode.showCompany = true
                cell?.mode = mode
                moreCell = cell
            }
            cell?.mode = mode
            cell?.useCellFrameCache(with: indexPath, tableView: tableView)
        }else{
            cell?.mode = mode
            cell?.useCellFrameCache(with: indexPath, tableView: tableView)
        }
        return cell!
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = privacyModel(title: status[indexPath.row], selected: false, showCompany:false)

        if currentSelectedRow == indexPath.row{
            mode.selected = true
            if currentSelectedRow == 2{
                mode.showCompany = true
                return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: PrivacyCellView.self, contentViewWidth: ScreenW)
            }
            
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: PrivacyCellView.self, contentViewWidth: ScreenW)
            
        }else{
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: PrivacyCellView.self, contentViewWidth: ScreenW)
        }
       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSelectedRow = indexPath.row
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    

}

extension PrivacySetting{
    
    private func initView(){
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.tableHeaderView = headerView
        self.tableView.tableFooterView = UIView.init()
        self.tableView.separatorStyle = .none
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentiy)
        self.tableView.register(PrivacyCellView.self, forCellReuseIdentifier: PrivacyCellView.identity())
        
    }
    
    // 等待 tableview 刷新后在执行
    private func refreshAfterAddItem(){
     
         self.tableView.reloadData()
         self.moreCell?.subItem.reloadData()
        
    }
}

// cell delegate

extension PrivacySetting: changeItems{
    
    func reloadCell(at index: Int) {
        self.tableView.reloadData()
        //self.tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
    }
    
    func addCompany(){
        let v = ignoreCompanyVC()
        
        // v 的回调函数 来刷新table界面
        v.refresh = refreshAfterAddItem
        self.present(v, animated: true, completion: nil)
        
    }
    
    
    
}
