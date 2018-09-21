//
//  MeetingCollectedVC.swift
//  internals
//
//  Created by ke.liang on 2018/7/1.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let notifiyName:String = "MeetingCollectedVC"


class MeetingCollectedVC: BaseViewController {

  
    private lazy var datas:[CareerTalkMeetingModel] = []
    
    internal lazy var table:UITableView = { [unowned self] in
        let tb = UITableView.init(frame: self.view.frame)
        tb.dataSource = self
        tb.delegate = self
        tb.allowsMultipleSelectionDuringEditing = true
        tb.tableFooterView = UIView()
        tb.register(CareerTalkCell.self, forCellReuseIdentifier: CareerTalkCell.identity())
        tb.backgroundColor = UIColor.viewBackColor()
        tb.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)

        
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(operation), name: NSNotification.Name.init(notifiyName), object: nil)
        
    }
    
    
    override func setViews() {
        
        
        self.view.addSubview(table)
           _ = table.sd_layout().topEqualToView(self.view)?.bottomEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}



extension MeetingCollectedVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datas.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CareerTalkCell.identity(), for: indexPath) as! CareerTalkCell
        let job =  datas[indexPath.row]
        
        cell.mode = job
        cell.useCellFrameCache(with: indexPath, tableView: tableView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let job = datas[indexPath.row]
        return  tableView.cellHeight(for: indexPath, model: job, keyPath: "mode", cellClass: CareerTalkCell.self, contentViewWidth: ScreenW)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing{
            return
        }
        
        let mode = self.datas[indexPath.row]
        let show = CareerTalkShowViewController()
        show.meetingID = mode.id
        self.navigationController?.pushViewController(show, animated: true)
        
        
        
    }
    
    
    
}


extension MeetingCollectedVC{
    @objc private func operation(_ sender: Notification){
        let info = sender.userInfo as? [String:String]
        if let action = info?["action"]{
            if action == "edit"{
                self.table.setEditing(true, animated: false)
            }else if action == "cancel"{
                self.table.setEditing(false, animated: false)
            }else if action == "selectAll"{
                for index in 0..<datas.count{
                    self.table.selectRow(at: IndexPath.init(row: index, section: 0), animated: true, scrollPosition: .bottom)
                }
                
            }else if action == "unselect"{
                self.table.selectRow(at: nil, animated: false, scrollPosition: .top)
            }else if action == "delete"{
                if let selected = self.table.indexPathsForSelectedRows{
                    var deletedRows:[Int] = []
                    selected.forEach { indexPath in
                        deletedRows.append(indexPath.row)
                    }
                    // 扩展 批量删除元素
                    self.datas.remove(indexes: deletedRows)
                    // 服务器删除
                    self.table.reloadData()
                    
                }
            }
        }
        
    }
}

extension MeetingCollectedVC{
    private func loadData(){
        DispatchQueue.global(qos: .userInitiated).async {  [weak self] in
            Thread.sleep(forTimeInterval: 1)
            for _ in 0..<20{
                self?.datas.append(CareerTalkMeetingModel(JSON: ["id":"dqw-dqwd","companyModel":["id":"com-dqwd-5dq","icon":"sina","name":"公司名字","describe":"达瓦大群-dqwd","isValidate":true,"isCollected":false,"address":["地址1","地址2"],"industry":["教育","医疗","化工"]],"college":"北京大学","address":"教学室二"
                    ,"isValidate":true,"isCollected":false,"icon":"car","start_time":Date().timeIntervalSince1970,"end_time":Date().timeIntervalSince1970 + TimeInterval(3600*2),"name":"北京高华证券有限责任公司宣讲会但钱当前无多群","source":"上海交大"])!)
            }
            DispatchQueue.main.async {
                self?.didFinishloadData()
            }
        }
        
    }
}




