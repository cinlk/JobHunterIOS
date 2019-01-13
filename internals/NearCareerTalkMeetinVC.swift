//
//  NearCareerTalkMeetinVC.Swift
//  internals
//
//  Created by ke.liang on 2018/6/30.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class NearCareerTalkMeetinVC: BaseViewController {

    
    // 全局的变量 MARK
    private lazy var location:String = ""
    
    
    private lazy var datas:[CareerTalkMeetingModel] = []
    
    
    
    private lazy var table:UITableView = { [unowned self] in
        let tb = UITableView()
        tb.tableFooterView = UIView()
        tb.delegate = self
        tb.dataSource = self
        tb.backgroundColor = UIColor.viewBackColor()
        tb.register(CareerTalkCell.self, forCellReuseIdentifier: CareerTalkCell.identity())
        return tb
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        loadData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func setViews() {
        
        self.view.addSubview(table)
         _  = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
        
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



extension NearCareerTalkMeetinVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CareerTalkCell.identity(), for: indexPath) as! CareerTalkCell
        cell.mode = self.datas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = self.datas[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CareerTalkCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let mode = self.datas[indexPath.row]
        let show = CareerTalkShowViewController()
        show.hidesBottomBarWhenPushed = true
        show.meetingID = mode.id
        self.navigationController?.pushViewController(show, animated: true)
    }
    
}

extension NearCareerTalkMeetinVC{
    
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Thread.sleep(forTimeInterval: 3)
            for _ in 0..<20{
                self?.datas.append(CareerTalkMeetingModel(JSON: ["id":"dqw-dqwd","companyModel":["id":"com-dqwd-5dq","icon":"sina","name":"公司名字","describe":"达瓦大群-dqwd","isValidate":true,"isCollected":false,"address":["地址1","地址2"],"industry":["教育","医疗","化工"]],"college":"北京大学","address":"教学室二"
                    ,"isValidate":true,"isCollected":false,"icon":"car","start_time":Date().timeIntervalSince1970,"end_time":Date().timeIntervalSince1970 + TimeInterval(3600*2),"name":"北京高华证券有限责任公司宣讲会但钱当前无多群","source":"上海交大"])!)
            }
            
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
        }
    }
    
}
