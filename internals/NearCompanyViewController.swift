//
//  NearCompanyViewController.swift
//  internals
//
//  Created by ke.liang on 2018/6/30.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper

fileprivate let distance:Double = 1000_0


class NearCompanyViewController: BaseViewController {
    
    
    private lazy var datas:[NeayByCompanyModel] = []
    
    private lazy var table:UITableView = { [unowned self] in
        
        let tb = UITableView()
        tb.tableFooterView = UIView()
        tb.delegate = self
        tb.dataSource = self
        tb.backgroundColor = UIColor.viewBackColor()
        tb.register(NearCompanyTableViewCell.self, forCellReuseIdentifier: NearCompanyTableViewCell.identity())
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
        self.hiddenViews.append(table)
        self.view.addSubview(table)
        
        _  = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
        
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
    
    
    deinit {
        print("deinit aroundCompany \(String.init(describing: self))")
    }
}



extension NearCompanyViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NearCompanyTableViewCell.identity(), for: indexPath) as! NearCompanyTableViewCell
        cell.mode = self.datas[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let mode = self.datas[indexPath.row]
        let companyVC = CompanyMainVC()
        companyVC.companyID = mode.companyID
        companyVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(companyVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = self.datas[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: NearCompanyTableViewCell.self, contentViewWidth: GlobalConfig.ScreenW)
        
    }
}

extension NearCompanyViewController{
    
    private func loadData(){
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
   
            let location = SingletoneClass.shared.getLocation()
            
            NetworkTool.request(.nearyByCompany(latitude: location.coordinate.latitude.binade, longtitude: location.coordinate.longitude.binade, distance: distance), successCallback: { (data) in
                if let json = data as? [String: Any], let j =   Mapper<NeayByCompanyModel>.init().mapArray(JSONObject: json["body"]){
                    self?.datas = j
                    
                    DispatchQueue.main.async {
                        self?.didFinishloadData()
                    }
                }
                
            }, failureCallback: { (error) in
                DispatchQueue.main.async(execute: {
                    self?.showError()
                })
                
            })
           
        }
    }
    
}

