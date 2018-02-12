//
//  addSkillVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/15.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import SVProgressHUD

class addSkillVC: UITableViewController {

    
    private lazy var backgroundView:UIView = { [unowned self] in
        // 不能用self.bound.frame, y 会上移64像素
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH))
        v.backgroundColor = UIColor.lightGray
        v.alpha = 0.5
        let guest = UITapGestureRecognizer.init()
        guest.addTarget(self, action: #selector(hiddenBackGround))
        guest.numberOfTapsRequired  = 1
        v.addGestureRecognizer(guest)
        v.isUserInteractionEnabled = true
        
        return v
        
        }()
    
    private lazy var pickView:itemPickerView = {
        let pick = itemPickerView.init(frame: CGRect.init(x: 0, y: ScreenH, width: ScreenW, height: 200))
        pick.backgroundColor = UIColor.white
        UIApplication.shared.windows.last?.addSubview(pick)
        pick.pickerDelegate = self
        return pick
        
    }()
    
    private lazy var pickViewOriginXY:CGPoint = CGPoint.init(x: 0, y: 0)
    
    private var selected:SelectItemUtil = SelectItemUtil.shared
    
    private var pManager:personModelManager = personModelManager.shared
    
    private var skillData:person_skills = person_skills.init()
    
    private var currentType:personBaseInfo  = .none
    private var currentRow:Int = 0
    
    private var typeName:[String:(personBaseInfo,Int)] = [:]
    
    weak var delegate:refreshResumeItem?
    
    private var pickPosition:[personBaseInfo:[Int:Int]] = [:]
    
    // cellCatch
    private var textViewCellCache:textViewCell?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView.init()
        self.pickViewOriginXY = pickView.origin
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .plain, target: self, action: #selector(save))
        self.tableView.register(AddItemCell.self, forCellReuseIdentifier: AddItemCell.identity())
        
        self.tableView.register(textViewCell.self, forCellReuseIdentifier: textViewCell.identity())
        
        
        for (index,item) in skillData.getItemList().enumerated(){
            typeName[item.rawValue] = (item,index)
        }
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
        return skillData.getItemList().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row ==  skillData.getItemList().count - 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: textViewCell.identity(), for: indexPath) as! textViewCell
            currentType = skillData.getItemList()[indexPath.row]
            cell.textView.text = skillData.getItemByType(type: .describe)
            cell.textView.delegate = self
            textViewCellCache = cell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: AddItemCell.identity(), for: indexPath) as! AddItemCell
            currentType = skillData.getItemList()[indexPath.row]
            
            cell.mode = (currentType.rawValue,skillData.getItemByType(type: currentType))
            cell.textFiled.delegate = self
            return cell
        }
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row ==  skillData.getItemList().count - 1 {
            return textViewCell.cellHeight()
        }
        return AddItemCell.cellHeight()
    }



}


extension addSkillVC: itemPickerDelegate{
    
    func quitPickerView(_ picker: UIPickerView) {
        self.hiddenBackGround()
        
    }
    
    func changeItemValue(_ picker: UIPickerView, value: String, position: [Int : Int]) {
        
        skillData.changeValue(pinfoType: currentType, value: value)
        pickPosition[currentType] = position
        self.tableView.reloadRows(at: [IndexPath.init(row: currentRow, section: 0)], with: .none)
        self.hiddenBackGround()
    }
    
}


extension addSkillVC {
    
    @objc private func hiddenBackGround(){
        
        self.navigationController?.view.willRemoveSubview(backgroundView)
        backgroundView.removeFromSuperview()
        UIView.animate(withDuration: 0.3, animations: {
            self.pickView.origin = self.pickViewOriginXY
            
        }) { (bool) in
            
        }
        
    }
    
    private func showPickView(){
        
        self.view.endEditing(true)
        self.navigationController?.view.addSubview(backgroundView)
        UIView.animate(withDuration: 0.3, animations: {
            self.pickView.frame = CGRect.init(x: 0, y: ScreenH - 200, width: ScreenW, height: 200)
        }, completion: { (bool) in
            
        })
    }
    
    @objc func save(){
        
        self.view.endEditing(true)
       
        let res:(Bool,String) = skillData.isValidate()
        if res.0{
            //
        
            pManager.skillInfos.append(skillData)
            self.navigationController?.popViewController(animated: true)
            self.delegate?.refreshDataByType(.skill)
            
            
        }else{
            // 禁止navigationbar 点击
            self.navigationController?.view.addSubview(backgroundView)
            backgroundView.isUserInteractionEnabled = false
            self.navigationController?.navigationBar.isUserInteractionEnabled = false
            SVProgressHUD.show(UIImage.init(named: "error")!, status: "请检查输入")
            SVProgressHUD.dismiss(withDelay: 3, completion: {  [unowned self] in
                self.backgroundView.isUserInteractionEnabled = true
                self.backgroundView.removeFromSuperview()
                self.navigationController?.view.willRemoveSubview(self.backgroundView)
                self.navigationController?.navigationBar.isUserInteractionEnabled = true

            })
            
        }
        
    }
    
    
}


extension addSkillVC: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let currentName = textField.placeholder!
        
        //  pickerview 不显示键盘，记录当前的row和type
        switch  currentName {
        case personBaseInfo.skill.rawValue:
            pickView.mode = ("技能", selected.getItems(name: "技能")!)
            pickView.setPosition(position: pickPosition[.startTime])
            showPickView()
            currentType = (typeName[currentName]?.0)!
            currentRow = (typeName[currentName]?.1)!
            return false
       
            
        default:
            break
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 进入编辑状态才记录 row 和 type
        let currentName = textField.placeholder!
        currentType = (typeName[currentName]?.0)!
        currentRow = (typeName[currentName]?.1)!
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if  typeName.keys.contains(textField.placeholder!){
            skillData.changeValue(pinfoType: currentType, value: textField.text!)
            self.tableView.reloadRows(at: [IndexPath.init(row: currentRow, section: 0)], with: .none)
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension addSkillVC: UITextViewDelegate{
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    // 判断内容，设置placeholder label 显示
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == nil || textView.text.isEmpty{
            textViewCellCache?.placeHolderLabel.isHidden = false
        }else{
            textViewCellCache?.placeHolderLabel.isHidden = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        skillData.changeValue(pinfoType: .describe, value: textView.text)
        self.tableView.reloadRows(at: [IndexPath.init(item: skillData.getItemList().count-1, section: 0)], with: .none)
        
    }
}
