//
//  add_projectVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/15.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit



fileprivate let placeholder:String = "输入实习经历,500子以内"
fileprivate let limitWords:Int = 500
fileprivate let VCtilte:String = "添加实习经历"
class add_internVC: UITableViewController {

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
    
    private var projectData:personInternInfo = personInternInfo(JSON: [:])!
    
    private var currentType:ResumeInfoType  = .none
    private var currentRow:Int = 0
    
    private var typeName:[String:(ResumeInfoType,Int)] = [:]
    
    weak var delegate:addResumeItenDelegate?

    
    private var pickPosition:[ResumeInfoType:[Int:Int]] = [:]
    
    private var tmpTextCell:textViewCell?
    private var currentField:UITextField?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView.init()
        self.tableView.isScrollEnabled = false
        self.tableView.backgroundColor = UIColor.viewBackColor()
        
        self.pickViewOriginXY = pickView.origin
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .plain, target: self, action: #selector(save))
        self.tableView.register(AddItemCell.self, forCellReuseIdentifier: AddItemCell.identity())
        
        self.tableView.register(textViewCell.self, forCellReuseIdentifier: textViewCell.identity())
        
        
        for (index,item) in projectData.getItemList().enumerated(){
            typeName[item.rawValue] = (item,index)
        }

       
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = VCtilte
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = "实习/项目经历"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return projectData.getItemList().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      
        if indexPath.row ==  projectData.getItemList().count - 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: textViewCell.identity(), for: indexPath) as! textViewCell
            currentType = projectData.getItemList()[indexPath.row]
            cell.textView.text = projectData.getItemByType(type: .describe)
            cell.textView.delegate = self
            cell.placeHolderLabel.text = placeholder
            tmpTextCell = cell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: AddItemCell.identity(), for: indexPath) as! AddItemCell
            currentType = projectData.getItemList()[indexPath.row]
            cell.mode = (currentType.rawValue,projectData.getItemByType(type: currentType))
            cell.textFiled.delegate = self
            return cell
        }
       
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if indexPath.row ==  projectData.getItemList().count - 1 {
            return textViewCell.cellHeight()
        }
        return AddItemCell.cellHeight()
    }


}

extension add_internVC: itemPickerDelegate{
    
    func quitPickerView(_ picker: UIPickerView) {
        self.hiddenBackGround()
        
    }
    
    func changeItemValue(_ picker: UIPickerView, value: String, position: [Int : Int]) {
        
        projectData.changeValue(type: currentType, value: value)
        pickPosition[currentType] = position
        self.tableView.reloadRows(at: [IndexPath.init(row: currentRow, section: 0)], with: .none)
        self.hiddenBackGround()
    }
    
}

extension add_internVC {
    
    @objc private func hiddenBackGround(){
        
       
        let img = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        img.image = #imageLiteral(resourceName: "arrow_xl")
        currentField?.rightView = img
        
        
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
        
         let res:(Bool,String) = projectData.isValidate()
         if res.0{
            //
            pManager.mode?.internInfo.append(projectData)
            self.navigationController?.popViewController(animated: true)
            self.delegate?.addNewItem(type: .intern)
            
            
        }else{
            
            //
            let hub = MBProgressHUD.showAdded(to: self.tableView, animated: true)
            hub.mode = .customView
            hub.customView = UIImageView.init(image: #imageLiteral(resourceName: "error").changesize(size: CGSize.init(width: 25, height: 25)))
            hub.label.text = "错误原因"
            hub.margin = 10
            hub.label.textColor = UIColor.white
            hub.bezelView.backgroundColor = UIColor.backAlphaColor()
            hub.removeFromSuperViewOnHide = true
            
            self.navigationController?.navigationBar.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                
                hub.hide(animated: true)
                self.navigationController?.navigationBar.isUserInteractionEnabled = true
            }
            
        }
        
    }
    
}

extension add_internVC: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let currentName = textField.placeholder!
        let img = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        img.image = #imageLiteral(resourceName: "arrow_mr")
        //  pickerview 不显示键盘，记录当前的row和type
        switch  currentName {
            
        case "开始时间":
            currentField = textField
            pickView.mode = ("生日", selected.getItems(name: "生日")!)
            pickView.setPosition(position: pickPosition[.startTime])
            currentField?.rightView = img
            showPickView()
            
            currentType = (typeName[currentName]?.0)!
            currentRow = (typeName[currentName]?.1)!
            return false
        case "结束时间":
            currentField = textField
            pickView.mode = ("生日", selected.getItems(name: "生日")!)
            pickView.setPosition(position: pickPosition[.endTime])
            currentField?.rightView = img
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
            projectData.changeValue(type: currentType, value: textField.text!)
            self.tableView.reloadRows(at: [IndexPath.init(row: currentRow, section: 0)], with: .none)
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


extension add_internVC: UITextViewDelegate{

    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty{
            tmpTextCell?.placeHolderLabel.isHidden = false
            return
        }
        
        tmpTextCell?.placeHolderLabel.isHidden = true
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
       tmpTextCell?.placeHolderLabel.isHidden = true
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == nil {
           tmpTextCell?.placeHolderLabel.isHidden = false
           
        }else{
            tmpTextCell?.placeHolderLabel.isHidden = true
        }
        projectData.changeValue(type: .describe, value: textView.text)
        //self.tableView.reloadRows(at: [IndexPath.init(item: projectData.getItemList().count-1, section: 0)], with: .none)
        
    }
    
    
}
