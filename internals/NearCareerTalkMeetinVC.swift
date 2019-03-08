//
//  NearCareerTalkMeetinVC.Swift
//  internals
//
//  Created by ke.liang on 2018/6/30.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper

// 默认查询附近10公里以内的数据
fileprivate let distance:Double = 1000_0.0

class NearCareerTalkMeetinVC: BaseViewController {

    
    private lazy var datas:[NearByTalkMeetingModel] = []
    
    
    
    private lazy var table:UITableView = { [unowned self] in
        let tb = UITableView()
        tb.tableFooterView = UIView()
        tb.delegate = self
        tb.dataSource = self
        tb.backgroundColor = UIColor.viewBackColor()
        tb.register(NearMeetingsTableViewCell.self, forCellReuseIdentifier: NearMeetingsTableViewCell.identify())
        return tb
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        loadData()
        
        // Do any additional setup after loading the view.
    }

   
    

    
    override func setViews() {
        
        self.view.addSubview(table)
         _  = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
        
        self.hiddenViews.append(table)
        
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: NearMeetingsTableViewCell.identify(), for: indexPath) as! NearMeetingsTableViewCell
        cell.mode = self.datas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = self.datas[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: NearMeetingsTableViewCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let mode = self.datas[indexPath.row]
        let show = CareerTalkShowViewController()
        show.hidesBottomBarWhenPushed = true
        show.meetingID = mode.meetingID ?? ""
        self.navigationController?.pushViewController(show, animated: true)
    }
    
}

extension NearCareerTalkMeetinVC{
    
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let myLocation = SingletoneClass.shared.getLocation()
            
            NetworkTool.request(.nearByMeetings(latitude: myLocation.coordinate.latitude.binade, longitude: myLocation.coordinate.longitude.binade, distance: distance), successCallback: { data in
                // TODO  判断返回状态码
                if let json  = data as? [String:Any], let body =                 Mapper<NearByTalkMeetingModel>.init().mapArray(JSONObject: json["body"])
                {
                //json["body"] as? [NearByTalkMeetingModel]{
                    
                    DispatchQueue.main.async(execute: {
                        self?.datas = body
                        self?.didFinishloadData()
                    })
                    
                }else{
                    self?.showError()
                }
                
            }, failureCallback: { (error) in
                DispatchQueue.main.async {
                    self?.showError()
                }
            })
            
            
        }
    }
    
}
