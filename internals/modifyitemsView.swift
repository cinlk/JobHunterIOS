//
//  modify_education.swift
//  internals
//
//  Created by ke.liang on 2018/2/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

// 修改和删除
protocol modifyItemDelegate: class {
    
    func modifiedItem(indexPath:IndexPath)
    func deleteItem(indexPath: IndexPath)
}



class modifyitemView: UITableViewController {

    
  
    
    
    // 修改的行数
    private var modifyIndexPath:IndexPath?
    
    weak var delegate:modifyItemDelegate?
    
   
    private var diction:[ResumeInfoType:String] = [:]
    private var keys:[ResumeInfoType] = []
    private var onlyPickerResumeType:[ResumeInfoType] = []
    private var placeholdStr:String = ""
    
    
    private var infosDict:Dictionary<ResumeSubItems,[Any]> = [:]
    
    var mode:(viewType:ResumeSubItems, indexPath:IndexPath, data:Any)?{
        didSet{
            
            guard  let mode = mode else {
                return
            }
            
            self.modifyIndexPath = mode.indexPath
            
            switch mode.viewType {
            case .education:
                
                if let data = mode.data as? personEducationInfo{
                     setData(data)
                }
            
            case .works:
                 if let data = mode.data as? personInternInfo{
                    setData(data)
                }
            case .project:
                if let data = mode.data as? personProjectInfo{
                    setData(data)
                }
            
            case .schoolWork:
                if let data = mode.data as? studentWorkInfo{
                    setData(data)
                }
            case .practice:
                if let data = mode.data as? socialPracticeInfo{
                    setData(data)
                }
            case .other:
                if let data = mode.data as? resumeOther{
                    setData(data)
                }
            case .skills:
                if let data = mode.data as? personSkillInfo{
                    setData(data)
                }
                
            default:
                break
            }
            
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .plain, target: self, action: #selector(save))
    
        tableView.bounces = false
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = UIColor.viewBackColor()
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(singleButtonCell.self, forCellReuseIdentifier: singleButtonCell.identity())
        tableView.register(AddItemCell.self, forCellReuseIdentifier: AddItemCell.identity())
        tableView.register(textViewCell.self, forCellReuseIdentifier: textViewCell.identity())
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "修改" + self.mode!.viewType.describe
        self.navigationController?.insertCustomerView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.navigationItem.title = ""
         self.navigationController?.removeCustomerView()
        
     }
    
    

}



extension modifyitemView{
    private func setData(_ data:reumseInfoAction){
        diction = data.getTypeValue()
        keys = data.getItemList()
        onlyPickerResumeType = data.getPickerResumeType()
        placeholdStr = data.placeHolder
        
    }
}

extension modifyitemView{
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 最后的删除按钮
        if keys.count  == indexPath.row{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: singleButtonCell.identity(), for: indexPath) as! singleButtonCell
            cell.btnType = .delete
            cell.deleteItem = self.deleteItem
            
            return cell
            
        }else if keys.count - 1 == indexPath.row{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: textViewCell.identity(), for: indexPath) as! textViewCell
            
            cell.textView.text = diction[.describe]
            cell.updateText = { value in
                self.diction[.describe] =  value
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
            cell.placeHolderLabel.text = placeholdStr
            cell.placeHolderLabel.isHidden = diction[.describe]!.isEmpty ? false : true
            return cell
            
            
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: AddItemCell.identity(), for: indexPath) as! AddItemCell
            cell.onlyPickerResumeType = onlyPickerResumeType
            cell.mode = (type: keys[indexPath.row],title: diction[keys[indexPath.row]]!)
            cell.delegate = self
            
            return cell

        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if keys.count  == indexPath.row{
           return singleButtonCell.cellHeight()
        }else{
           
           return indexPath.row == keys.count - 1 ?  textViewCell.cellHeight() : AddItemCell.cellHeight()
        }
        
        
    }
    
    
    
}

extension modifyitemView: AddItemCellUpdate{
    
    func updateTextfield(value: String, type: ResumeInfoType){
        diction[type] = value
        self.tableView.reloadRows(at: [IndexPath.init(row: keys.index(of: type)!, section: 0)], with: .automatic)
    }

}



extension modifyitemView {
    
    @objc func save(){
        // 放在第一行，保证更新数据
        self.view.endEditing(true)
        
        
        var res:[String:Any] = [:]
        diction.forEach{
            res[$0.key.rawValue] = $0.value
        }
        
        
        // 判断数据
        guard  let indexPath = modifyIndexPath, let mode = mode else {
            return
        }
        
        
        let row = indexPath.row
        switch  mode.viewType {
        case .education:
             if let data = personEducationInfo(JSON: res){
               print(data.toJSON())
               personModelManager.shared.mode?.educationInfo[row] = data
             }
        case .works:
             if let data = personInternInfo(JSON: res){
                personModelManager.shared.mode?.internInfo[row] = data

             }
            
        case .project:
            if let data = personProjectInfo(JSON: res){
                 personModelManager.shared.mode?.projectInfo[row] = data
            }
           
        case .practice:
            if  let data = socialPracticeInfo(JSON: res){
                personModelManager.shared.mode?.practiceInfo[row] = data
            }
            
        case .other:
            if let data = resumeOther(JSON: res){
                personModelManager.shared.mode?.resumeOtherInfo[row] = data
            }
            
        case .schoolWork:
             if let data = studentWorkInfo(JSON: res){
                 personModelManager.shared.mode?.studentWorkInfo[row] = data
             }
           
        case .skills:
            if  let data = personSkillInfo(JSON: res){
                personModelManager.shared.mode?.skills[row] = data
            }
            
        default:
            break
        }
        
        self.delegate?.modifiedItem(indexPath: indexPath)
        
        self.navigationController?.popViewController(animated: true)

    }
    
    func deleteItem(){
        
        self.view.endEditing(true)
        
        
        guard  let indexPath = modifyIndexPath, let mode = mode  else {
            return
        }
        let row = indexPath.row
        switch  mode.viewType {
        case .education:
            personModelManager.shared.mode?.educationInfo.remove(at: row)
        case .works:
            personModelManager.shared.mode?.internInfo.remove(at: row)
        case .project:
            personModelManager.shared.mode?.projectInfo.remove(at: row)
        case .practice:
            personModelManager.shared.mode?.practiceInfo.remove(at: row)
        case .other:
            personModelManager.shared.mode?.resumeOtherInfo.remove(at: row)
        case .schoolWork:
            personModelManager.shared.mode?.studentWorkInfo.remove(at: row)
        case .skills:
            personModelManager.shared.mode?.skills.remove(at: row)
        default:
            break
        }
        
        
        self.delegate?.deleteItem(indexPath: indexPath)
        
        self.navigationController?.popViewController(animated: true)

    }
    
}




