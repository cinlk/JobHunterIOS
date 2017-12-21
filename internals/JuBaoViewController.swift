//
//  JuBaoViewController.swift
//  internals
//
//  Created by ke.liang on 2017/12/21.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class JuBaoViewController: UIViewController {

    
    let resonse = ["薪资不符合","要求不真实","公司信息不真实","HR无法联系","工作地方不符合","其他"]
    //  举报那个job
    var jobId:String?
    
    lazy var table:UITableView = {
       var table = UITableView.init()
       table.backgroundColor = UIColor.white
       table.delegate = self
       table.dataSource = self
        
       
       return table
        
    }()
    
    lazy var comfirm:UIButton = {
        
        let btn = UIButton.init(frame: CGRect.zero)
        btn.backgroundColor = UIColor.blue
        btn.setTitle("提交", for: .normal)
        btn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        return btn
    
    }()
    
    let bv = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))

    
    lazy var tableheader:UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        v.backgroundColor = UIColor.lightGray
        let label = UILabel.init(frame: CGRect.init(x: 10, y: 2, width: 120, height: 30))
        v.addSubview(label)
        label.text =  "请选择原因"
        label.font = UIFont.systemFont(ofSize: 12)
        return v
        
    }()
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(table)
        self.table.tableFooterView = bv
        self.table.tableHeaderView = tableheader
        bv.addSubview(comfirm)
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        _  = comfirm.sd_layout().leftSpaceToView(bv,10)?.rightSpaceToView(bv,10)?.topSpaceToView(bv,20)?.bottomSpaceToView(bv,5)
    }
    
    

}

extension JuBaoViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resonse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = resonse[indexPath.row]
        cell.textLabel?.textAlignment = .left
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        return indexPath
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    
    
}

extension JuBaoViewController{
    @objc func submit(){
        if let index = self.table.indexPathsForSelectedRows{
            print(index)
            self.navigationController?.popViewController(animated: true)
        }else{
            print("alert 请选择")
        }
        
    }
}
