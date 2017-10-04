//
//  deliveredHistory.swift
//  internals
//
//  Created by ke.liang on 2017/10/1.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class deliveredHistory: UIViewController,UIScrollViewDelegate {

    
    
    //test data
    var data:[Dictionary<String,String>] = []
    var reviewDAta:[Dictionary<String,String>] = []
    var failData:[Dictionary<String,String>] = []
    
    
    var line  = UIView()
    
    lazy var l1:UIButton = {
        var b = UIButton.init()
        b.setTitle("全部", for: .normal)
        b.setTitleColor(UIColor.gray, for: .normal)
        b.setTitleColor(UIColor.green, for: .selected)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        b.tag =  101
        b.addTarget(self, action: #selector(switchitem), for: .touchUpInside)
        return b
    }()
    
    
    lazy var l2:UIButton = {
        var b = UIButton.init()
        b.setTitle("被查看", for: .normal)
        b.setTitleColor(UIColor.gray, for: .normal)
        b.setTitleColor(UIColor.green, for: .selected)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        b.tag =  102
        b.addTarget(self, action: #selector(switchitem), for: .touchUpInside)
        return b

    }()
    
    lazy var l3:UIButton = {
        var b = UIButton.init()
        b.setTitle("待沟通", for: .normal)
        b.setTitleColor(UIColor.gray, for: .normal)
        b.setTitleColor(UIColor.green, for: .selected)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        b.tag =  103
        b.addTarget(self, action: #selector(switchitem), for: .touchUpInside)
        return b

    }()

    lazy var l4:UIButton = {
        var b = UIButton.init()
        b.setTitle("面试", for: .normal)
        b.setTitleColor(UIColor.gray, for: .normal)
        b.setTitleColor(UIColor.green, for: .selected)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        b.tag =  104
        b.addTarget(self, action: #selector(switchitem), for: .touchUpInside)
        return b

    }()
    
    lazy var l5:UIButton = {
        var b = UIButton.init()
        b.setTitle("不合适", for: .normal)
        b.setTitleColor(UIColor.gray, for: .normal)
        b.setTitleColor(UIColor.green, for: .selected)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        b.tag =  105
        b.addTarget(self, action: #selector(switchitem), for: .touchUpInside)
        return b

    }()
    
    
    lazy var topitem:UIView =  {
       
        var v = UIView()

        let bottomLine = UIView()
        bottomLine.backgroundColor  = UIColor.lightGray

        v.addSubview(bottomLine)
        _ = bottomLine.sd_layout().bottomEqualToView(v)?.widthIs(320)?.heightIs(1)

        return v
        
    }()
    
    // scrollerview
    
    lazy var t1:UITableView = {
       
        var table  = UITableView.init()
        table.backgroundColor = UIColor.white
        table.tableFooterView =  UIView()
        table.register(UINib(nibName:"deliveredJobs", bundle:nil), forCellReuseIdentifier: "jobstatus")
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 44
        return table
    }()
    
    
    lazy var t2:UITableView = {
        
        var table  = UITableView.init()
        table.backgroundColor = UIColor.gray
        table.tableFooterView =  UIView()
        table.register(UINib(nibName:"deliveredJobs", bundle:nil), forCellReuseIdentifier: "jobstatus")
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 44
        return table
    }()

    
    lazy var t3:UITableView = {
        
        var table  = UITableView.init()
        table.backgroundColor = UIColor.green
        table.tableFooterView =  UIView()
        table.register(UINib(nibName:"deliveredJobs", bundle:nil), forCellReuseIdentifier: "jobstatus")
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 44
        return table
    }()
    
    
    lazy var t4:UITableView = {
        
        var table  = UITableView.init()
        table.backgroundColor = UIColor.brown
        table.tableFooterView =  UIView()
        table.register(UINib(nibName:"deliveredJobs", bundle:nil), forCellReuseIdentifier: "jobstatus")
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 44
        return table
    }()

    
    lazy var t5:UITableView = {
        
        var table  = UITableView.init()
        table.backgroundColor = UIColor.orange
        table.tableFooterView =  UIView()
        table.register(UINib(nibName:"deliveredJobs", bundle:nil), forCellReuseIdentifier: "jobstatus")
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 44
        return table
    }()
    
    
    


    
    
    lazy var scroller:UIScrollView = {
       var scroll =  UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        // 一页一页翻
        scroll.isPagingEnabled  = true
        //到达最后页面不需要回弹
        scroll.bounces = false
        return scroll
        
    }()
    
    
    
    override func viewDidLoad() {
        
        
        
        
        self.navigationItem.title = "投递历史"
        super.viewDidLoad()
        self.view.backgroundColor  = UIColor.white
        
        line.backgroundColor = UIColor.green
        self.topitem.addSubview(line)
        
        
       
        
        self.view.addSubview(topitem)
        
        self.view.addSubview(scroller)
        
        _ = line.sd_layout().bottomSpaceToView(topitem,0.5)?.leftSpaceToView(topitem,10)?.widthIs(50)?.heightIs(2)
        
        _ = topitem.sd_layout().topSpaceToView(self.navigationController?.navigationBar,1)?.widthIs(self.view.frame.width)?.heightIs(30)
        _ = scroller.sd_layout().topSpaceToView(topitem,0)?.widthIs(self.view.frame.width)?.heightIs(self.view.height - 64 - 30)
        
        
        topitem.addSubview(l1)
        topitem.addSubview(l2)
        topitem.addSubview(l3)
        topitem.addSubview(l4)
        topitem.addSubview(l5)
        _ = self.l1.sd_layout().leftSpaceToView(topitem,10)?.bottomSpaceToView(topitem,5)?.widthIs(50)?.heightIs(20)
        _ = self.l2.sd_layout().leftSpaceToView(self.l1,10)?.bottomSpaceToView(topitem,5)?.widthIs(50)?.heightIs(20)
        _ = self.l3.sd_layout().leftSpaceToView(self.l2,10)?.bottomSpaceToView(topitem,5)?.widthIs(50)?.heightIs(20)
        _ = self.l4.sd_layout().leftSpaceToView(self.l3,10)?.bottomSpaceToView(topitem,5)?.widthIs(50)?.heightIs(20)
        _ = self.l5.sd_layout().leftSpaceToView(self.l4,10)?.bottomSpaceToView(topitem,5)?.widthIs(50)?.heightIs(20)

        
        
        t1.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: scroller.frame.height)
        t2.frame = CGRect(x:self.view.frame.width, y: 0, width: self.view.frame.width, height: scroller.frame.height)
        t3.frame = CGRect(x: self.view.frame.width*2, y: 0, width: self.view.frame.width, height: scroller.frame.height)
        
        t4.frame = CGRect(x: self.view.frame.width*3, y: 0, width: self.view.frame.width, height: scroller.frame.height)
        
        t5.frame = CGRect(x: self.view.frame.width*4, y: 0, width: self.view.frame.width, height: scroller.frame.height)
        
        t1.delegate = self
        t1.dataSource = self
        
        
        t2.delegate = self
        t2.dataSource = self
        
        t3.delegate = self
        t3.dataSource = self
        
        t4.delegate = self
        t4.dataSource = self
        
        t5.delegate = self
        t5.dataSource = self
        
        
        scroller.addSubview(t1)
        scroller.addSubview(t2)
        scroller.addSubview(t3)
        scroller.addSubview(t4)
        scroller.addSubview(t5)
        
        scroller.contentSize = CGSize(width: self.view.frame.width * 5, height: scroller.frame.height)
        scroller.delegate = self
        
        
        
       // all  数据
       data = TestData.getAllDelivers()
       reviewDAta = TestData.getReview()
       failData = TestData.getfail()
       // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
          
    }
 
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    
    
  
    
    // 左右滑动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scroller{
            let offset = scroller.contentOffset.x
            if 0 <= offset  && offset < 320{
                self.l1.isSelected = true
                self.l2.isSelected = false
                self.l3.isSelected = false
                self.l4.isSelected = false
                self.l5.isSelected = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.line.center.x = self.l1.center.x
                }, completion: nil)
                // 刷新数据
                self.t1.reloadData()
                
                
            }
            else if 320 <= offset && offset < 320*2 {
                self.l1.isSelected = false
                self.l2.isSelected = true
                self.l3.isSelected = false
                self.l4.isSelected = false
                self.l5.isSelected = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.line.center.x = self.l2.center.x
                }, completion: nil)
                
                self.t2.reloadData()

            }
            else if 320*2 <= offset && offset < 320*3{
                self.l1.isSelected = false
                self.l2.isSelected = false
                self.l3.isSelected = true
                self.l4.isSelected = false
                self.l5.isSelected = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.line.center.x = self.l3.center.x
                }, completion: nil)
                
                self.t3.reloadData()

            }
            else if 320*3 <= offset && offset < 320*4{
                self.l1.isSelected = false
                self.l2.isSelected = false
                self.l3.isSelected = false
                self.l4.isSelected = true
                self.l5.isSelected = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.line.center.x = self.l4.center.x
                }, completion: nil)
                
                self.t4.reloadData()

            }else{
                self.l1.isSelected = false
                self.l2.isSelected = false
                self.l3.isSelected = false
                self.l4.isSelected = false
                self.l5.isSelected = true
                UIView.animate(withDuration: 0.2, animations: {
                    self.line.center.x = self.l5.center.x
                }, completion: nil)
                
                self.t5.reloadData()

            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // TODO
    func getData(){
        
    }

}


extension deliveredHistory:UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var  cell  =  tableView.dequeueReusableCell(withIdentifier: "jobstatus", for: indexPath) as? deliveredJobs
        if cell == nil{
            cell =  deliveredJobs()
        }
        
        if tableView  == self.t1{
            let item = data[indexPath.row]
            cell?.logo.image = UIImage(named: item["image"]!)
         
            cell?.creattime.text = (item["createTime"]!)
            cell?.jobname.text = (item["jobname"]!)
            cell?.locateAndCompany.text = (item["locate"]!) + "|" + (item["companyName"]!)
            cell?.status.text  = (item["currentstatus"]!)
            
        }else if tableView == self.t2{
            let item = reviewDAta[indexPath.row]
            cell?.logo.image = UIImage(named: item["image"]!)
            
            cell?.creattime.text = (item["createTime"]!)
            cell?.jobname.text = (item["jobname"]!)
            cell?.locateAndCompany.text = (item["locate"]!) + "|" + (item["companyName"]!)
            cell?.status.text  = ""
            
        }else if tableView == self.t5{
            let item = failData[indexPath.row]
            cell?.logo.image = UIImage(named: item["image"]!)
            
            cell?.creattime.text = (item["createTime"]!)
            cell?.jobname.text = (item["jobname"]!)
            cell?.locateAndCompany.text = (item["locate"]!) + "|" + (item["companyName"]!)
            cell?.status.text  = ""

        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView  == self.t1{
            return data.count
        }
        else if tableView  == self.t2{
            return reviewDAta.count
        }
        else if tableView == self.t5{
            return failData.count
        }
        // TODO 其他类型数据
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        let view = jobstatusView()
        
        if tableView  == t1{
            var item = data[indexPath.row]
            view.jobDetail = item
            view.current = ["status":item["currentstatus"]!]
            view.status =  TestData.findByid(id: item["id"]!)
            
            
        }else if tableView == t2{
            var item = reviewDAta[indexPath.row]
            view.jobDetail = item
            view.current = ["status":item["currentstatus"]!]
            view.status  = TestData.findByid(id: item["id"]!)
            
        }else if tableView == t3{
            
        }else if tableView == t4{
            
        }else{
            
            var item = failData[indexPath.row]
            view.jobDetail = item
            // response 字数限制
            view.current = ["status":item["currentstatus"]!,"response":"经验不匹配,能力不匹配"]
            view.status = TestData.findByid(id: item["id"]!)
        }
        // 子视图 返回lable修改为空
        let backButton =  UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton

        
        self.navigationController?.pushViewController(view, animated: true)

        
    }
    
    
}

// 切换
extension deliveredHistory{
    func switchitem(sender:UIButton){
        
        sender.isSelected  = true
        for item in self.topitem.subviews{
            if item.isKind(of: UIButton.self) && item.tag != sender.tag{
                (item as! UIButton).isSelected = false
            }
        }
        
        // 计算第几页
        let page  = sender.tag - 101
        self.scroller.setContentOffset(CGPoint(x:page*320,y:0), animated: true)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.line.center.x = sender.center.x
        }, completion: nil)
        
    }
}
