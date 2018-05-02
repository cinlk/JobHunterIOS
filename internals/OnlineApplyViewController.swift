//
//  OnlineApplyViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu
import ObjectMapper


class OnlineApplyViewController: BasePositionItemViewController {

    
    // 网申数据
    private var datas:[OnlineApplyModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        loadData()
        print("网申")
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    
    override func setViews() {
        
        table.register(OnlineApplyCell.self, forCellReuseIdentifier: OnlineApplyCell.identity())
        table.dataSource = self
        table.delegate = self
        
        super.setViews()
        
        // 筛选回调
        industryKind.passData = { name in
            print(name)
            self.dropMenu.changeMenu(title: name, at: 1)
        }
        cityMenu.passData = { city in
            print(city)
            
        }
    }
    
    
    override func didFinishloadData() {
        super.didFinishloadData()
        self.table.reloadData()
        
    }
    
    
    override func reload() {
        super.reload()
        loadData()
    }
    
    
    override func sendRequest(){
        
        //
        self.datas.removeAll()
        self.table.reloadData()
    }
    
    

}



extension  OnlineApplyViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: OnlineApplyCell.identity(), for: indexPath) as! OnlineApplyCell
        cell.mode = datas[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = datas[indexPath.row]
        return table.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: OnlineApplyCell.self, contentViewWidth: ScreenW)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mode = datas[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: false)
        // 招聘未过期
        if mode.isValidate!{
            if mode.outer == true && mode.content == nil{
                //跳转外部连接
                let wbView = baseWebViewController()
                
                guard let urlLink = mode.link else {return}
                wbView.mode = urlLink
                wbView.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(wbView, animated: true)
            }else{
                // 内部网申数据 或 外部网申但是content有内容
                let show = OnlineApplyShowViewController()
                guard let id = mode.id else { return }
                // 传递id
                show.onlineApplyID = id
                
                show.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(show, animated: true)
            }
            
        }
        
    }
    
    
    
}



extension OnlineApplyViewController{
    
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async {  [weak self] in
            Thread.sleep(forTimeInterval: 3)
            for _ in 0..<20{
               
                self?.datas.append(Mapper<OnlineApplyModel>().map(JSON: ["id":"fq-4320-dqwd","companyModel":["id":"dqw-dqwd","name":"公司名",
                "college":"北京大学","describe":"大哇多无多首先想到的肯定是结束减速的代理方法：scrollViewDscrollViewDidEndDecelerating代理方法的，如果做过用3个界面+scrollView实现循环滚动展示图片，那么基本上都会碰到这么问题。如何准确的监听翻页？我的解决的思路如下达瓦大文大无大无多无大无大无多哇大无多无飞啊飞分为飞飞飞达瓦大文大无大无多哇付达瓦大文大无付多无dwadwadadawdawde吊袜带挖多哇建外大街文档就frog忙不忙你有他们今天又摸排个人票买房可免费课时费\n个人个人，二哥，二\n吊袜带挖多，另外的码问了；吗\n","address":["地址1","地址2"],"icon":"sina","type":["教育","医疗","化工"],"webSite":"https://www.baidu.com","tags":["标签1","标签1测试","标签89我的当前","当前为多","迭代器","群无多当前为多群当前","达瓦大群无多", "当前为多当前的群","当前为多无", "当前为多群无多","杜德伟七多"],"isValidate":true,"isCollected":true,],"end_time":"2017","start_time":"2018","positionAddress":["成都","重庆"],"content":"dqwdqwdqwddqwdqwdqwddqwdqwdqwddqwdqwdqwdqwdqwdwqdqwdqwdqw","outer":true,
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    "majors":["土木工程","软件工程","其他"],"positions":["设计","测试","销售"],"link":"http://campus.51job.com/padx2018/index.html","isApply":false,"isValidate":true,"isCollected":true,"name":"网申测试"])!)
                
            }
            
            
            
            DispatchQueue.main.async {
                
                self?.didFinishloadData()
            }
        }
    }
}

