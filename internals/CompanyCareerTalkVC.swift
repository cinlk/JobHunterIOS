//
//  CompanyCareerTalkVC.swift
//  internals
//
//  Created by ke.liang on 2018/6/18.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class CompanyCareerTalkVC: BaseViewController {

    
    
    
    
    internal var mode:CompanyModel?
    
    
    private var datas:[CareerTalkMeetingModel] = []
    
    
    // deleagte
    weak var delegate:CompanySubTableScrollDelegate?
    
    
    internal lazy var table:UITableView = {
        let tb = UITableView()
        tb.backgroundColor = UIColor.viewBackColor()
        let hearder = UIView(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: CompanyMainVC.headerViewH))
        tb.tableHeaderView = hearder
        tb.tableFooterView = UIView()
        tb.contentInsetAdjustmentBehavior = .never
        tb.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 30, right: 0)
        tb.register(CareerTalkCell.self, forCellReuseIdentifier: CareerTalkCell.identity())
        tb.dataSource = self
        tb.delegate = self
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
        _ = table.sd_layout().leftEqualToView(self.view)?.topEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
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

extension CompanyCareerTalkVC: UITableViewDataSource, UITableViewDelegate{
    
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
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CareerTalkCell.self, contentViewWidth: ScreenW)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let mode = self.datas[indexPath.row]
        let show = CareerTalkShowViewController()
        show.hidesBottomBarWhenPushed = true
        show.meetingID = mode.id
        self.navigationController?.pushViewController(show, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
}


extension CompanyCareerTalkVC{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        if offsetY > 0{
            delegate?.scrollUp(view: self.table, height: offsetY)
        }else{
            delegate?.scrollUp(view: self.table, height: 0)
        }
    }
}

extension CompanyCareerTalkVC{
    
    private func loadData(){
        
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Thread.sleep(forTimeInterval: 2)
            for _ in 0..<20{
                if let data = CareerTalkMeetingModel(JSON: ["id":"dqw-dqwd","companyModel":["id":"com-dqwd-5dq",
                                                                                            "icon":"sina","name":"公司名字","describe":"达瓦大群-dqwd","isValidate":true,"isCollected":false,"address":["地址1","地址2"],"industry":["教育","医疗","化工"]],
                                                            "college":"北京大学","address":"教学室二"
                    ,"isValidate":true,"isCollected":false,"icon":"car","start_time":Date().timeIntervalSince1970,"end_time":Date().timeIntervalSince1970 + TimeInterval(3600*3),
                     "name":"北京高华证券有限责任公司宣讲会但钱当前无多群","source":"上海交大",
                     "content":"举办方：电院举办时间：2018年4月25日 18:00~20:00  \n举办地点：上海交通大学 - 上海市东川路800号电院楼群3-100会议室 单位名称：北京高华证券有限责任公司 联系方式：专业要求：不限、信息安全类、自动化类、计算机类、电子类、软件工程类"]){
                      self?.datas.append(data)
                }
              
                
                
            }
            
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
        }
        
        
        
    }
}
