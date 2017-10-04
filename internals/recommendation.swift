//
//  recommendation.swift
//  internals
//
//  Created by ke.liang on 2017/10/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class recommendation: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var data:[Dictionary<String,String>]!
    var table:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor  = UIColor.white

        self.navigationItem.title =  "推荐职位"
        // 我的订阅
        
        let sub =  UIBarButtonItem.init(title: "我的订阅", style: .plain, target: self, action: #selector(addSub))
        
        sub.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.blue,
                                    NSFontAttributeName : UIFont.systemFont(ofSize: 14)], for: .normal)
        self.navigationItem.rightBarButtonItem  = sub
        data = self.loadJobs()
        
        
        table =  UITableView()
        table.frame  = self.view.frame
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        
        self.table.register(jobdetailCell.self, forCellReuseIdentifier: "job")
        // Do any additional setup after loading the view.
        
        self.view.addSubview(table)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell  =  table.dequeueReusableCell(withIdentifier: "job", for: indexPath) as? jobdetailCell
        if cell == nil{
            cell  = jobdetailCell()
        }
        cell?.createCells(items: data[indexPath.row])
        cell?.selectionStyle = .none
        return cell!
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: false)
        
        let detail =  JobDetailViewController()
        detail.infos = data[indexPath.row]
        // 子视图 返回lable修改为空
        let backButton =  UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(detail, animated: true)

        
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension recommendation {
    
    func loadJobs()->[Dictionary<String,String>]{
        
        let datas = [["image":"swift","companyName":"apple","jobname":"码农","locate":"北京","salary":"150-190元/天","createTime":"09-01","times":"4天/周","time":"6个月","hired":"可转正","scholar":"本科"],
                     ["image":"onedriver","companyName":"microsoft","jobname":"AI","locate":"上海","salary":"150-190元/天","createTime":"09-01","times":"4天/周","time":"6个月","hired":"可转正","scholar":"本科"],
                     ["image":"fly","companyName":"宝骏","jobname":"设计师","locate":"上海","salary":"150-190元/天","createTime":"09-01","times":"4天/周","time":"6个月","hired":"可转正","scholar":"本科"]
        ]
        
        return datas
    }
    
    func addSub(){
        
        let subscribleView = subscribleItem()
        let backButton =  UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationController?.pushViewController(subscribleView, animated: true)
        
    }
}
