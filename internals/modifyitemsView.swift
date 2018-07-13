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





class modifyitemView: BaseActionResumeVC {
    
    // 修改的行数
    private var modifyIndexPath:IndexPath?
    
    weak var delegate:modifyItemDelegate?
    
   
    private var placeholdStr:String = ""
    
    
    private var infosDict:Dictionary<ResumeSubItems,[Any]> = [:]
    
    
    var mode:(viewType:ResumeSubItems, indexPath:IndexPath, data:Any)?{
        didSet{
            
            guard  let mode = mode else {
                return
            }
            
            self.modifyIndexPath = mode.indexPath
            
            self.title =  "修改" + self.mode!.viewType.describe
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
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(editStatus), name: NSNotification.Name.init(addResumeInfoNotify), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func currentViewControllerShouldPop() -> Bool {
        
        
        if self.isEdit{
            let alertController = UIAlertController(title: nil, message: "编辑尚未结束，确定返回吗？", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "继续编辑", style: .default) { (_) in
                
            }
            alertController.addAction(alertAction)
            let cancelAction = UIAlertAction(title: "放弃修改", style: .cancel) { (_) in
                self.navigationController?.popvc(animated: true)
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
            
        }
        
        // 未保存
        if self.isChange{
            
            let alertController = UIAlertController(title: nil, message: "修改尚未保存，确定返回吗？", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "保存并返回", style: .default) { (_) in
                self.save()
            }
            alertController.addAction(alertAction)
            let cancelAction = UIAlertAction(title: "放弃保存", style: .cancel) { (_) in
                self.navigationController?.popvc(animated: true)
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
        }
        
        return true 
 
        
    }


}



extension modifyitemView{
    private func setData(_ data:reumseInfoAction){
        guard let kv = data.getTypeValue() else {
            return
        }
        diction = kv
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
                self.isChange = true
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
        isChange = true 
        self.tableView.reloadRows(at: [IndexPath.init(row: keys.index(of: type)!, section: 0)], with: .automatic)
    }

}



extension modifyitemView {
    
    @objc func save(){
        if super.checkValue() == false{
            return
        }
        
        
        // 判断数据
        guard  let indexPath = modifyIndexPath, let mode = mode else {
            return
        }
        
        
        let row = indexPath.row
        pManager.modifyItemBy(type: mode.viewType, row: row, res: res)
        
        self.delegate?.modifiedItem(indexPath: indexPath)
        
        self.navigationController?.popvc(animated: true)

    }
    
    func deleteItem(){
        
        self.view.endEditing(true)
        
        
        guard  let indexPath = modifyIndexPath, let mode = mode  else {
            return
        }
        let row = indexPath.row
        
        pManager.deleteItemBy(type: mode.viewType, row: row)
        
        
        self.delegate?.deleteItem(indexPath: indexPath)
        
        self.navigationController?.popvc(animated: true)

    }
    
}




