//
//  closedJobView.swift
//  internals
//
//  Created by ke.liang on 2018/1/9.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


private let section  = 1
private let jobHeadH:CGFloat = 170

class closedJobView: UITableViewController {

    fileprivate lazy var tableHeaderView:closedJobHeaderView = {
       
        let jh = closedJobHeaderView(frame: CGRect.zero)
        jh.backgroundColor = UIColor.white
        return jh
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        
    }

    override func viewWillLayoutSubviews() {
        _ = self.tableView.tableHeaderView?.sd_layout().leftEqualToView(self.tableView)?.rightEqualToView(self.tableHeaderView)?.topEqualToView(self.tableHeaderView)?.heightIs(160)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return section
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "recruiter", for: indexPath) as?  RecruiterCell{
            
            
            return cell
        }
        return UITableViewCell.init()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }

}

extension closedJobView{
    private func setViews(){
        self.navigationItem.title = "职位详情"
        self.view.backgroundColor = UIColor.lightGray
        self.tableView.tableFooterView = UIView.init()
        self.tableView.tableHeaderView  = tableHeaderView
        self.tableView.register(UINib(nibName:"RecruiterCell", bundle: nil), forCellReuseIdentifier: "recruiter")
        
        
    }
}


private let title:String = "该职位已经停止招聘"
private let topViewH:CGFloat = 30

private class closedJobHeaderView:UIView{
    
    lazy var jobhead:JobDetailHeader = { [unowned self] in
        let jh = JobDetailHeader.init(frame: CGRect.zero)
        //jh.createInfos(item: ["jobName":"test","address":"beijing","salary":"2000","类型":"社招"])
        return jh
    }()
    
    lazy var bootomView:UIView = UIView.init(frame: CGRect.zero)
    
    lazy var topView:UIView = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.red
        label.text = title
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        let block = UIView.init(frame: CGRect.zero)
        block.backgroundColor = UIColor.lightGray
        let v = UIView.init(frame: CGRect.zero)
        v.backgroundColor = UIColor.orange
        v.addSubview(label)
        v.addSubview(block)
        _ = block.sd_layout().bottomEqualToView(v)?.leftEqualToView(v)?.rightEqualToView(v)?.heightIs(10)
        _ = label.sd_layout().topSpaceToView(v,2.5)?.leftSpaceToView(v,10)?.rightSpaceToView(v,10)?.bottomSpaceToView(block,2.5)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setViews()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setViews(){
        self.addSubview(topView)
        self.addSubview(jobhead)
        self.addSubview(bootomView)
       
        bootomView.backgroundColor = UIColor.lightGray
        
        _ = topView.sd_layout().topEqualToView(self)?.rightEqualToView(self)?.leftEqualToView(self)?.heightIs(topViewH)
        _ = bootomView.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)?.heightIs(10)
        _ = jobhead.sd_layout().topSpaceToView(topView,0)?.leftEqualToView(self)?.rightEqualToView(self)?.bottomSpaceToView(bootomView,0)
        
        
    }
}
