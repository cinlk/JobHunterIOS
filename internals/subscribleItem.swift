//
//  subscribleItem.swift
//  internals
//
//  Created by ke.liang on 2017/10/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit


fileprivate let campus = "campus"
fileprivate let intern = "intern"
fileprivate let section = 2

class subscribleItem: UITableViewController {

    
    // 数据保持在本地(校招,实习)

    var interndata:[Dictionary<String,String>]?
    var campusdata:[Dictionary<String,String>]?
    
    
    
    //条件数据
    lazy var data = localData.shared

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setView()
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "我的订阅"
        self.loadData()
       
    }
 
}

extension subscribleItem{
    
    private func setView(){
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName:"subjobitem", bundle:nil), forCellReuseIdentifier: subjobitem.identity())
        self.tableView.register(subscribeSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: subscribeSectionHeaderView.identity())
        //self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        let size = CGSize.init(width: 25, height: 25)
        let add = UIImage.barImage(size: size, offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "plus")
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem.init(image: add, style: .plain, target: self, action: #selector(addItem))
        
    }
    
    private func loadData(){
        campusdata  =  data.getSubscribeByType(type: campus)
        interndata  = data.getSubscribeByType(type: intern)
       
        self.tableView.reloadData()
        
    }
    @objc func addItem(){
        let condition =  subconditions()
        self.present(condition, animated: true, completion: nil)
        
    }
}


// table
extension subscribleItem{
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // #warning Incomplete implementation, return the number of sections
        return section
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return campusdata?.count ?? 0
        }
        return interndata?.count  ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: subjobitem.identity(), for: indexPath) as? subjobitem{
            switch indexPath.section{
            case 0:
                if let item = campusdata?[indexPath.row]{
                    cell.category.text  = item["职位类别"]
                    cell.locate.text = item["工作城市"]
                    cell.salary.text = item["薪资范围"]
                    cell.business.text = item["从事行业"]
                    //学历
                    cell.internDay.isHidden = true
                    cell.interdayIcon.isHidden = true
                }
                return cell
            case 1:
                if let item = interndata?[indexPath.row]{
                    cell.category.text = item["职位类别"]
                    cell.locate.text = item["实习城市"]
                    cell.salary.text = item["实习薪水"]
                    cell.business.text = item["从事行业"]
                    cell.internDay.text = item["实习天数"]
                    cell.internDay.isHidden = false
                    cell.interdayIcon.isHidden = false
                }
                return cell
            default:
                break
            }
            
        }
        return UITableViewCell.init()
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        if  let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: subscribeSectionHeaderView.identity()) as? subscribeSectionHeaderView{
            switch section{
            case 0:
                if let data =  self.campusdata, !data.isEmpty{
                    view.label.text = "校招"
                    return view
                }
            case 1:
                if let data =  self.interndata, !data.isEmpty{
                    view.label.text = "实习"
                    return view
                }
            default:
                break
            }
            
        }
        
        return UIView.init()
        
    }
  
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if  let data =  self.campusdata, !data.isEmpty {
                return subscribeSectionHeaderView.sectionHeight()
            }
            
        }else{
            if let data =  self.interndata, !data.isEmpty{
                return subscribeSectionHeaderView.sectionHeight()
            }
        }
        return  0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return subjobitem.cellHeight()
    }
    
    
    
    // cell 编辑
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    // 自定义cell 编辑方法
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        
        
        
        var editView:subconditions!
        
        let edit = UITableViewRowAction(style: .normal, title: "edit") { action, index in
            
            if indexPath.section  == 0 {
                let data = self.campusdata?[indexPath.row]
                editView = subconditions.init(modifyData: data, row: indexPath.row)
             
            }else{
                let data = self.interndata?[indexPath.row]
                editView = subconditions.init(modifyData: data, row: indexPath.row)
                
            }
            self.present(editView, animated: true, completion: nil)
        }
        
        edit.backgroundColor = UIColor.orange
        
        let delete = UITableViewRowAction(style: .normal, title: "delete") { action, index in

            
            if indexPath.section == 0{
                self.campusdata?.remove(at: indexPath.row)
                self.data.deleteSubscribeByIndex(type: campus, indexPath.row)
            }else{
                self.interndata?.remove(at: indexPath.row)
                self.data.deleteSubscribeByIndex(type: intern, indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            
        }
        delete.backgroundColor = UIColor.blue
        
        return [delete, edit]
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}


extension subscribleItem{
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //var contentOffSetY = scrollView.contentOffset.y
        
      
    }
    
    
   
}

private class  subscribeSectionHeaderView: UITableViewHeaderFooterView{
    
    lazy var label:UILabel = {
       let l = UILabel.init()
       l.font = UIFont.systemFont(ofSize: 15)
       l.textAlignment = .left
       return l
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(label)
        
        _ = label.sd_layout().leftSpaceToView(self.contentView,10)?.centerYEqualToView(self.contentView)?.widthIs(80)?.heightIs(15)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "subscribeSectionHeaderView"
    }
    
    class func sectionHeight()->CGFloat{
        return 20
    }
    
}
