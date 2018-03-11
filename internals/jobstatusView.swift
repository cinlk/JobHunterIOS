//
//  jobstatusView.swift
//  internals
//
//  Created by ke.liang on 2017/10/2.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit



fileprivate let JobViewH:CGFloat =  80
fileprivate let DescribeViewH:CGFloat =  70

class jobstatusView: UIViewController {

    var jobDetail:Dictionary<String,String>!
    var current:Dictionary<String,String>!
    var status:[Array<String>]!
    
    var hrResponse:String?
    
    
    lazy var jobItem:UIView = {  [unowned self] in
        let v = UIView.init(frame: CGRect.init(x: 0, y: NavH, width: ScreenW, height: JobViewH))
        v.backgroundColor = UIColor.white
        v.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init()
        tap.numberOfTouchesRequired = 1
        tap.addTarget(self, action: #selector(self.choose(_:)))
        v.addGestureRecognizer(tap)
        
        let j = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: v.frame.width, height: v.frame.height))
        j.backgroundColor = UIColor.orange
        v.addSubview(j)
        
        return v
        
    }()
    
    fileprivate lazy var describle:describleView = { [unowned self] in
        let desc = describleView.init(frame: CGRect.init(x: 0, y: NavH + JobViewH, width: ScreenW, height: DescribeViewH))
        
        return desc
    }()
    
    lazy var table:UITableView = { [unowned self] in
        
        let table = UITableView.init(frame: CGRect.init(x: 0, y: NavH + DescribeViewH + JobViewH, width: ScreenW, height: ScreenH -  DescribeViewH - JobViewH - NavH))
        table.backgroundColor = UIColor.lightGray
        table.delegate = self
        
        table.dataSource = self
        table.register(UINib(nibName:"statustage", bundle:nil), forCellReuseIdentifier: "bottom")
        table.tableFooterView =  UIView()
        table.separatorStyle = .none
        return table
        
    }()
    
    
    
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title  = "投递记录"
        self.view.addSubview(jobItem)
        self.view.addSubview(describle)
        
        self.view.addSubview(table)
        self.loadData()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

}

extension jobstatusView{
    @objc func choose(_ gest:UITapGestureRecognizer){
        let  job = JobDetailViewController()
        //job.infos = ["JobName":"测试","address":"北京","salary":"50万"]
        self.navigationController?.pushViewController(job, animated: true)
        
        
    }
    
    
    private func loadData(){
        if let res = self.hrResponse {
            self.describle.tagLabel.text = "hr反馈:"
            self.describle.contentLabel.text = res
        }else{
            self.describle.tagLabel.text = "投递反馈:"
            self.describle.contentLabel.text = "投递成功dwdwadaw当前为多哇多哇多达瓦大哇多无多"
        }
    
    }
}


extension jobstatusView:UITableViewDelegate,UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return status.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard status.count > 0 else {
            return UITableViewCell.init()
        }
        
        if let  cell = table.dequeueReusableCell(withIdentifier: "bottom", for: indexPath) as? statustage{
        
            if status.count - 1  == 0{
            
                cell.status.text =  status[0].first
                cell.time.text  = status[0].last
                cell.logo.image =  #imageLiteral(resourceName: "checked")
            
            }else{
                let data = status[indexPath.row]
                cell.logo.image = #imageLiteral(resourceName: "checked1")
                cell.status.text = data[0]
                cell.time.text = data[1]
                // 最后一个cell
                if indexPath.row  == status.count - 1{
                
                    cell.upline.isHidden = false
                }else if indexPath.row == 0{
                    cell.logo.image = #imageLiteral(resourceName: "checked")
                    cell.downline.isHidden = false
                }else{
                    cell.upline.isHidden = false
                    cell.downline.isHidden = false
                }
            
            }
        
            return cell
        }
        
        return UITableViewCell.init()
        
        
        
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
        
    }
    
    
    
}


private class describleView:UIView{
    
    
    
    
    lazy var topView:UIView = {
        let t = UIView.init(frame: CGRect.zero)
        t.backgroundColor = UIColor.lightGray
        return t
    }()
    
    lazy var bottomView:UIView = {
        let b = UIView.init(frame: CGRect.zero)
        b.backgroundColor = UIColor.lightGray
        return b
    }()
    
    lazy  var tagLabel:UILabel = {
       let l = UILabel.init(frame: CGRect.zero)
       l.font = UIFont.systemFont(ofSize: 15)
       l.sizeToFit()
       return l
    }()
    lazy var contentLabel:UILabel = {
        let l = UILabel.init(frame: CGRect.zero)
        l.font = UIFont.systemFont(ofSize: 15)
        l.lineBreakMode = .byWordWrapping
        l.sizeToFit()
        l.numberOfLines = 0
        return l
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.setView()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(){
        
        self.addSubview(topView)
        self.addSubview(bottomView)
        self.addSubview(tagLabel)
        self.addSubview(contentLabel)
        
        _  = topView.sd_layout().topEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(10)
        _  = bottomView.sd_layout().bottomEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(10)
        _  = tagLabel.sd_layout().centerYEqualToView(self)?.leftSpaceToView(self,10)?.widthIs(70)?.heightIs(20)
        _  = contentLabel.sd_layout().leftSpaceToView(tagLabel,2)?.topEqualToView(tagLabel)?.rightSpaceToView(self,10)?.heightIs(20)
        
        
       
    }
}


class jobstatusDesCell:UITableViewCell{
    
    
    var label:UILabel!
    var cstatus:UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        label = UILabel()
        label.text = "当前状态"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        
        cstatus = UILabel()
        cstatus.font = UIFont.boldSystemFont(ofSize: 12)
        self.contentView.addSubview(cstatus)
        
        self.contentView.addSubview(label)
        _ = label.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(60)?.heightIs(15)
        
        _ = cstatus.sd_layout().leftSpaceToView(label,10)?.topEqualToView(label)?.widthIs(120)?.heightIs(15)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "jobstatusDesCell"
    }
    
}




