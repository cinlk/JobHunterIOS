//
//  AddBaseInfoTableViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/20.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


// 添加
protocol addResumeItenDelegate: class {
    
    func addNewItem(type:ResumeSubItems)
    
}



class AddBaseInfoTableViewController: UITableViewController {
    
    
    
    private let pManager = personModelManager.shared
    
    
    internal var itemType:ResumeSubItems = .none{
        didSet{
            
            self.title = itemType.add
            switch itemType {
            case .education:
                if let data = personEducationInfo(JSON: [:]){
                    setData(data)
                }
            
            case .works:
                if let data = personInternInfo(JSON: [:]){
                    setData(data)
                }
                
            case .project:
                if let data = personProjectInfo(JSON: [:]){
                    setData(data)
                }

            case .schoolWork:
                if let data =  studentWorkInfo(JSON: [:]){
                    setData(data)
                }
                
            case .practice:
                if let data = socialPracticeInfo(JSON: [:]){
                    setData(data)
                }
            case .other:
                if let data = resumeOther(JSON: [:]){
                    setData(data)
                }
            
            case .skills:
                if let data = personSkillInfo(JSON: [:]){
                    setData(data)
                }
                
            default:
                break
            }
        }
    }
    
    
    internal var placeholder:String = "输入专业描述,500子以内"
    
    internal var diction:[ResumeInfoType:String] = [:]
    internal var keys:[ResumeInfoType] = []
    internal var onlyPickerResumeType:[ResumeInfoType] = []
    
    
    

    // 添加item代理
    weak var delegate:addResumeItenDelegate?
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.removeCustomerView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return keys.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == keys.count - 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: textViewCell.identity(), for: indexPath) as! textViewCell
            
            cell.textView.text = diction[.describe]
            cell.updateText = { value in
                self.diction[.describe] =  value
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
            cell.placeHolderLabel.text = placeholder
            cell.placeHolderLabel.isHidden = diction[.describe]!.isEmpty ? false : true
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: AddItemCell.identity(), for: indexPath) as! AddItemCell
            
            cell.onlyPickerResumeType = onlyPickerResumeType
            cell.mode = (type:keys[indexPath.row],title:diction[keys[indexPath.row]]!)
            cell.delegate = self
            return cell
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.row == keys.count - 1 ?  textViewCell.cellHeight() : AddItemCell.cellHeight()
    }
    
 
    

}


extension AddBaseInfoTableViewController{
    
    private func setData(_ data:reumseInfoAction){
        diction = data.getTypeValue()
        keys = data.getItemList()
        onlyPickerResumeType = data.getPickerResumeType()
        placeholder = data.placeHolder
        
    }
}

extension AddBaseInfoTableViewController{
    private func setViews(){
        
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.bounces = false
        self.tableView.tableFooterView = UIView.init()
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .plain, target: self, action: #selector(save))
        self.tableView.register(AddItemCell.self, forCellReuseIdentifier: AddItemCell.identity())
        self.tableView.register(textViewCell.self, forCellReuseIdentifier: textViewCell.identity())
        
    }
}

// pciker

extension AddBaseInfoTableViewController: AddItemCellUpdate{
    
 
    func updateTextfield(value: String, type: ResumeInfoType){
        diction[type] = value
        self.tableView.reloadRows(at: [IndexPath.init(row: keys.index(of: type)!, section: 0)], with: .automatic)
     }
    
    

    
}
//save

extension AddBaseInfoTableViewController{
    
    @objc func save(){
        
        self.view.endEditing(true)
        
        var res:[String:Any] = [:]
        diction.forEach{
            res[$0.key.rawValue] = $0.value
        }
        
        switch itemType {
        case .education:
            
            if let mode = personEducationInfo(JSON: res){
                pManager.mode?.educationInfo.append(mode)
            }
            
            
        case .works:
            
            if let mode = personInternInfo(JSON: res){
                pManager.mode?.internInfo.append(mode)
            }
        
        case .project:
            if let mode = personProjectInfo(JSON: res){
                pManager.mode?.projectInfo.append(mode)
            }
            
        case .schoolWork:
            if let mode = studentWorkInfo(JSON: res){
                pManager.mode?.studentWorkInfo.append(mode)
            }
        case .practice:
            if  let mode = socialPracticeInfo(JSON: res){
                pManager.mode?.practiceInfo.append(mode)
            }
            
        case .skills:
            if  let mode = personSkillInfo(JSON: res){
                pManager.mode?.skills.append(mode)
            }
        case .other:
            if let mode = resumeOther(JSON: res){
                pManager.mode?.resumeOtherInfo.append(mode)
            }
            
        default:
            break
        }
        
        delegate?.addNewItem(type: itemType)
        self.navigationController?.popViewController(animated: true)
    
        
    }
}




