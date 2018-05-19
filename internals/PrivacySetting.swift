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

class PrivacySetting: BaseTableViewController {



    private var currentSelectedRow:Int = 0
    // 选择数据
    private var mode:privateMode?{
        didSet{
            privateViewMode.shared.mode = mode!
        }
    }
    

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
        self.setViews()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "隐私设置"
        self.navigationController?.insertCustomerView()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        self.navigationController?.removeCustomerView()
        
    }
    
    override func setViews(){
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.tableHeaderView = headerView
        self.tableView.tableFooterView = UIView.init()
        self.tableView.separatorStyle = .none
        self.tableView.register(PrivacyCellView.self, forCellReuseIdentifier: PrivacyCellView.identity())
        
        
        super.setViews()
        
    }
    
    override func didFinishloadData(){
        
        super.didFinishloadData()
        self.tableView.reloadData()
    }
    
    override func showError(){
       super.showError()
    }
    
    override func reload(){
        super.reload()
        self.loadData()
        
    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mode?.list?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let lists = mode?.list else {
            return UITableViewCell()
        }
        
        if let  cell = tableView.dequeueReusableCell(withIdentifier: PrivacyCellView.identity(), for: indexPath) as?
            PrivacyCellView{
            
            cell.delegate = self
            
            
            let item = lists[indexPath.row]
            if item.isOn == true{
                currentSelectedRow = indexPath.row
            }
            // 显示屏蔽公司的cell
            if item.showCompany == true{
                moreCell = cell
            }
            
            cell.mode = item
            cell.useCellFrameCache(with: indexPath, tableView: tableView)
            
            return cell
            
        }
     
        return UITableViewCell()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = mode?.list else {
            return 0
        }

        
       return tableView.cellHeight(for: indexPath, model: item[indexPath.row], keyPath: "mode", cellClass: PrivacyCellView.self, contentViewWidth: ScreenW)
       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if currentSelectedRow != indexPath.row{
            mode?.list?[currentSelectedRow].isOn = false
        }
        mode?.list?[indexPath.row].isOn = true
        tableView.reloadData()
    }
    
  
    
}


// 这里加载
extension PrivacySetting{
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            Thread.sleep(forTimeInterval: 3)
            DispatchQueue.main.async(execute: {
                
                
                self?.mode = privateMode(JSON: ["list":[["name":"所有公司可见","isOn":false,"showCompany":false],["name":"只有投递公司可见","isOn":true,"showCompany":false],
                                                        ["name":"屏蔽指定公司","isOn":false,"showCompany":true],["name":"影藏简历","isOn":false,"showCompany":false]],
                                                "backListComp":["公司1","公司2","公司3"]])
                
                
                self?.didFinishloadData()
                
            })
        }
        
        
    }
}

extension PrivacySetting{
    
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
