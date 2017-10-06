//
//  subscribleItem.swift
//  internals
//
//  Created by ke.liang on 2017/10/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class subscribleItem: UITableViewController {

    
    // 数据保持在本地(校招,实习)

    var interndata:[Dictionary<String,String>]?
    var campusdata:[Dictionary<String,String>]?
    
    
    
    //条件数据
    var data = localData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.tableFooterView = UIView()
        
        self.tableView.register(UINib(nibName:"subjobitem", bundle:nil), forCellReuseIdentifier: "subjobitems")
        
        //新增加
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem.init(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: #selector(addItem))
        self.navigationItem.rightBarButtonItem?.imageInsets  = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        campusdata  =  data.getshezhaoCondtion()
        interndata  = data.getshixiCondtion()
        // 添加数据 后从新刷新table
        self.tableView.reloadData()
        print(campusdata)
        print(interndata)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Disspose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            
            if campusdata != nil{
                return campusdata!.count
            }
            
        }
        else{
            if interndata != nil{
                return interndata!.count
            }
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjobitems", for: indexPath) as! subjobitem
        // 校招
        if indexPath.section  == 0 {
            if let item  = campusdata?[indexPath.row]{
                    cell.leibie.text  = item["职位类别"]
                    cell.locate.text = item["工作城市"]
                    cell.salary.text = item["薪资范围"]
                    cell.hangye.text = item["从事行业"]
                    //学历
                    cell.shixiday.isHidden = true
                    cell.shixidaylog.isHidden = true
                    print(cell)
            }
           
            
        }else{
            if let item = interndata?[indexPath.row]{
            
            cell.leibie.text = item["职位类别"]
            cell.locate.text = item["实习城市"]
            cell.salary.text = item["实习薪水"]
            cell.hangye.text = item["从事行业"]
            cell.shixiday.text = item["实习天数"]
            
            cell.shixiday.isHidden = false
            cell.shixidaylog.isHidden = false
            
            }
        }
        
        
        // Configure the cell...

        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.font =  UIFont.systemFont(ofSize: 10)
        label.frame = CGRect(x: 5, y: 2, width: 50, height: 10)
        label.textAlignment = .left
        let view =  UITableViewHeaderFooterView.init()
        view.backgroundColor = UIColor.lightGray
        if section == 0 {
            if campusdata != nil && !((campusdata?.isEmpty)!){
                label.text = "校招"
            }else{
                return UIView()
            }
            
        }else{
            if interndata != nil && !((interndata?.isEmpty)!){
                label.text = "实习"
            }else{
                return UIView()
            }

        }
        view.addSubview(label)
        return view
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if campusdata != nil && !((campusdata?.isEmpty)!){
                
                return 15
            }
            
        }else{
            if interndata != nil && !((interndata?.isEmpty)!){
                return 15
            }
        }
        return  0
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
        
//        let more = UITableViewRowAction(style: .normal, title: "More") { action, index in
//            print("more button tapped")
//        }
//        more.backgroundColor = UIColor.lightGray
        
        let edit = UITableViewRowAction(style: .normal, title: "edit") { action, index in
            print("edit button tapped")
            
            if indexPath.section  == 0 {
                let data = self.campusdata?[indexPath.row]
                let editview  = editcondition()
                editview.editdata  = data
                editview.name["职位类型"] = "校招"
                editview.row  = indexPath.row
                
                let backButton =  UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
                self.navigationItem.backBarButtonItem = backButton
                
                self.navigationController?.pushViewController(editview, animated: true)

                
                
            }else{
                let data = self.interndata?[indexPath.row]
                let editview  = editcondition()
                editview.editdata = data
                editview.name["职位类型"] = "实习"
                editview.row  = indexPath.row

                let backButton =  UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
                self.navigationItem.backBarButtonItem = backButton
                
                self.navigationController?.pushViewController(editview, animated: true)

            }
        }
        
        edit.backgroundColor = UIColor.orange
        
        let delete = UITableViewRowAction(style: .normal, title: "delete") { action, index in
            print("delete button tapped")
            
            if indexPath.section == 0{
                self.campusdata?.remove(at: indexPath.row)
                self.data.deleteshezhaoCondition(index: indexPath.row)
            }else{
                self.interndata?.remove(at: indexPath.row)
                self.data.deleteShixiCondition(index: indexPath.row)
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
    
    func addItem(){
        let condition =  subconditions()
        self.present(condition, animated: true, completion: nil)
        
    }
}
