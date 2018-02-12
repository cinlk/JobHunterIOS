//
//  modify_items.swift
//  internals
//
//  Created by ke.liang on 2018/2/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

// 刷新主界面的section数据
protocol modofy_itemDelegate: class {
    
    func refreshItem(_ section:Int)
    
}

// 刷新当前界面item 数据
protocol refreshResumeItem:class {
    
    func refreshDataByType(_ ViewType:resumeViewType)
}

class listItemsView: UITableViewController {
    
    //private var items:[Any] = []
    private var pManager:personModelManager = personModelManager.shared
    private var count = 0
    private var section:Int = 0
    private var type:resumeViewType = .baseInfo
    
    var mode:(type:resumeViewType,section:Int)?{
        didSet{
            self.section = mode!.section
            self.type = mode!.type
            self.tableView.reloadData()
            self.navigationItem.title = self.type.rawValue
        }
    }
    

    
    weak var delegate:modofy_itemDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.orange
        
        self.tableView.register(ListItemCell.self, forCellReuseIdentifier: ListItemCell.identity())
        self.tableView.register(singleButtonCell.self, forCellReuseIdentifier: singleButtonCell.identity())
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.tableHeaderView = UIView.init()
        self.tableView.tableFooterView  = UIView.init()
        
    }

    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch type {
        case .education:
            count = pManager.educationInfos.count + 1
            return count
        case .project:
            count =  pManager.projectInfo.count + 1
            return count
        case .skill:
            count =  pManager.skillInfos.count + 1
            return count
        default:
            count = 1
            return count
        }
        
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        if count - 1  == indexPath.row {
            let cell = tableView.dequeueReusableCell(withIdentifier: singleButtonCell.identity(), for: indexPath) as!   singleButtonCell
            cell.btnType = .add
            cell.addMoreItem = self.addMore
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ListItemCell.identity(), for: indexPath) as!
            ListItemCell
         
            switch self.type {
            case .education:
                cell.mode = (type:self.type, obj:pManager.educationInfos[indexPath.row], row:row)
            case .project:
                 cell.mode = (type:self.type, obj:pManager.projectInfo[indexPath.row], row:row)
             case .skill:
                cell.mode = (type:self.type, obj:pManager.skillInfos[indexPath.row], row:row)
             default:
                break
            }
            cell.modifyCall = self.modify
            return cell
        }
        
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if count - 1 == indexPath.row{
            return  60
        }
        switch self.type {
        case .education:
            return 140
        case .project:
            return 140
        case .skill:
            return 70
        default:
            return 45
        }
    }
    


}



extension listItemsView{
    
    func modify(type:resumeViewType, row:Int){
        
            
        let view = modifyitemView()
        view.delegate = self
        view.mode = (type,row)
        self.navigationController?.pushViewController(view, animated: true)
     
        
    }
    
    func addMore(){
        switch  self.type {
        case .education:
            let view = add_educations()
            view.delegate = self
            self.navigationController?.pushViewController(view, animated: true)
        case .project:
            let view = add_projectVC()
            
            view.delegate = self
            self.navigationController?.pushViewController(view, animated: true)
        case .skill:
            let view =  addSkillVC()
            view.delegate = self
            self.navigationController?.pushViewController(view, animated: true)

            
        default:
            break
        }
    }
//    func addMore(name:String){
//       
//        switch name {
//        case "教育经历":
//            let view = add_educations()
//            view.delegate = self
//            self.navigationController?.pushViewController(view, animated: true)
//            
//        case "项目经历":
//            break
//        case "技能":
//            break
//            
//        default:
//            break
//        }
//    }
    
    
}

// 公共delegate 方法
extension listItemsView: refreshResumeItem{
    
    func refreshDataByType(_ ViewType:resumeViewType){
        self.type = ViewType
        self.tableView.reloadData()
        self.delegate?.refreshItem(self.section)
    }
}

extension listItemsView: educationModifyDelegate{
    
    func refreshModifiedData(index: Int, name: String) {
        self.tableView.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .none)
        self.delegate?.refreshItem(self.section)
    }
    
    
    // 刷新主界面
    func refreshNewData() {
        
        self.tableView.reloadData()
        self.delegate?.refreshItem(self.section)
    }
    
    
}
