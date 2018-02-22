//
//  HelpsVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let headerH:CGFloat = 160
fileprivate let rowItem:Int = 2
fileprivate let sectionH:CGFloat = 25

class HelpsVC: UITableViewController {

    
    
    private lazy var  headerView:MessageMainHeaderView = {  [unowned self] in
        let v = MessageMainHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: headerH))
        v.backgroundColor = UIColor.brown
        return v
    }()
    
    
    private var guideItem:[showitem] = [showitem.init(name: "指导1", image: "bell", bubbles: 0),
                                        showitem.init(name: "指导2", image: "bell", bubbles: 0),
                                        showitem.init(name: "指导3", image: "bell", bubbles: 0),
                                        showitem.init(name: "指导4", image: "bell", bubbles: 0)]
    
    
    
    
    
    // cell selected
    private var selectedCellIndexPath:[IndexPath] = []
    
    private var datas:[Int:[String:String]] = [0:["title":"啊哈哈哈","content":"达瓦大群多群无多无当前为多群无多"],1:["title":"吊袜带挖群多当前为多","content":"dwd迭代器我单独群无多当前为多群无多群无当前为多群无多群无当前为多群无多群无多当前为多群无多无当前为多群无多无"]]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "帮助"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datas.keys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: expansionCell.identity(), for: indexPath) as? expansionCell
        if cell == nil{
            cell = expansionCell.init(style: .default, reuseIdentifier: expansionCell.identity())
            
        }
        if let item = datas[indexPath.row]{
            if selectedCellIndexPath.contains(indexPath){
                cell?.mode = (title:item["title"]!, detail:item["content"]!, selected:true)
            }else{
                cell?.mode = (title:item["title"]!, detail:item["content"]!, selected:false)
            }
            
        }
      
        
        // 不显示遮挡部分
        cell?.layer.masksToBounds = true
        
        return cell!
        
    }
    
    
    // secion
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect.zero)
        v.backgroundColor = UIColor.init(r: 234, g: 234, b: 234)
        let label = UILabel.init(frame: CGRect.zero)
        label.text = "常见问题"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        v.addSubview(label)
        _ = label.sd_layout().leftSpaceToView(v,10)?.topSpaceToView(v,5)?.bottomSpaceToView(v,5)?.widthIs(200)
        return v
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionH
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // 带cell内容高度
        if selectedCellIndexPath.contains(indexPath){
            let str = datas[indexPath.row]!["content"]!
            let strCGRect = str.getStringCGRect(size: CGSize.init(width: ScreenW - 20, height: 0), font: UIFont.systemFont(ofSize: 14))
            return strCGRect.height +   50
        }else{
            return expansionCell.cellHeight()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let index = selectedCellIndexPath.index(of: indexPath){
            selectedCellIndexPath.remove(at: index)
        }else{
            selectedCellIndexPath.append(indexPath)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}


extension HelpsVC{
    
    private func initView(){
        self.tableView.tableFooterView = UIView.init()
        
         buildStackItemView(items: guideItem, ItemRowNumbers: rowItem, mainStack: headerView.mainStack, itemButtons: &headerView.itemButtons)
        headerView.itemButtons?.forEach { [unowned self] (btn) in
            btn.addTarget(self, action: #selector(chooseSub(btn:)), for: .touchUpInside)
        }
        
        self.tableView.tableHeaderView = headerView
        self.tableView.register(expansionCell.self, forCellReuseIdentifier: expansionCell.identity())
        
    }
}


extension HelpsVC{
    @objc private func chooseSub(btn:UIButton){
        print(btn)
    }
}


// 取消悬挂的sectionview, 检查滑动区间，设置contentInset值
extension HelpsVC{
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 最低值
        let threhold:CGFloat = headerH - NavH
        
        if scrollView == self.tableView{
            let offsetY = scrollView.contentOffset.y
            if offsetY >= threhold && offsetY < threhold + sectionH{
                scrollView.contentInset = UIEdgeInsetsMake(threhold - offsetY, 0, 0, 0)
            }else if offsetY >= threhold + sectionH{
                scrollView.contentInset = UIEdgeInsetsMake(-sectionH, 0, 0, 0)
            }else{
                 scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            }
        }
    }
}
