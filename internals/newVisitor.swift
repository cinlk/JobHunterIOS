//
//  newVisitor.swift
//  internals
//
//  Created by ke.liang on 2018/1/8.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class newVisitor: UITableViewController {

    private var mode:[VisitorHRModel] = []
    
    private lazy var  errorView:ErrorPageView = {  [unowned self] in
        let eView = ErrorPageView.init(frame: self.view.bounds)
        eView.isHidden = true
        // 再次刷新
        eView.reload = reload
        
        return eView
    }()
    
    
    private lazy var hub:MBProgressHUD = { [unowned self] in
        
        let  hub = MBProgressHUD.showAdded(to: self.backHubView, animated: true)
        hub.mode = .indeterminate
        hub.label.text = "加载数据"
        hub.removeFromSuperViewOnHide = false
        hub.margin = 10
        hub.label.textColor = UIColor.black
        return hub
        
    }()
    
    
    // tableview 是第一个view，不能直接使用为hub的背景view
    private lazy var backHubView:UIView = { [unowned self] in
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH))
        view.backgroundColor = UIColor.white
        self.navigationController?.view.insertSubview(view, at: 1)
        view.isHidden = true
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.setView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationItem.title = ""
        
        // 
        backHubView.removeFromSuperview()
        hub.removeFromSuperview()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.mode.count 
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: visitorCell.identity(), for: indexPath) as? visitorCell{
            cell.mode = mode[indexPath.row]
            return cell
        }
        return UITableViewCell.init()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView.cellHeight(for: indexPath, model: mode[indexPath.row], keyPath: "mode", cellClass: visitorCell.self, contentViewWidth: ScreenW)
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        let hrVC = publisherControllerView()
        //hrVC.mode = 
    }
    
    

}


extension newVisitor{
    
    
    
    private func setView(){
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.tableFooterView = UIView.init()
        self.tableView.register(visitorCell.self, forCellReuseIdentifier: visitorCell.identity())
        
        hub.show(animated: true)
        self.tableView.isHidden = true
        backHubView.isHidden = false
    }
    
    private func didFinishloadData(){
        hub.hide(animated: true)
        backHubView.isHidden = true
        self.tableView.isHidden = false
        errorView.isHidden = true
        hub.removeFromSuperview()
        self.tableView.reloadData()
    }
    
    private func showError(){
        hub.hide(animated: true)
        errorView.isHidden = false
        backHubView.isHidden = false
    }
    
    private func reload(){
        
        hub.show(animated: true)
        backHubView.isHidden = false
        self.errorView.isHidden = true
        self.loadData()
        
    }
    
    
}
extension newVisitor{
    
    private func loadData(){
        //self.data
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            Thread.sleep(forTimeInterval: 3)
            
            for _ in 0..<10{
                self?.mode.append(VisitorHRModel(JSON: ["iconURL":"avartar","company":"小公司","position":"HRBP","visit_time":"2017-12-27","jobName":"销售经理","tag":"招聘"])!)
            }
            
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
            
        }
       
        
    }
    
 
}
