//
//  add_educations.swift
//  internals
//
//  Created by ke.liang on 2018/2/13.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import SVProgressHUD



class add_educations: UITableViewController {

    
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
    
    private var education:person_education = person_education.init()
    
    private var currentType:personBaseInfo  = .none
    private var currentRow:Int = 0
    
    private var typeName:[String:(personBaseInfo,Int)] = [:]
    
    weak var delegate:refreshResumeItem?
    
    private var pickPosition:[personBaseInfo:[Int:Int]] = [:]
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView.init()
        self.pickViewOriginXY = pickView.origin
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .plain, target: self, action: #selector(save))
        self.tableView.register(AddItemCell.self, forCellReuseIdentifier: AddItemCell.identity())
        
        
        for (index,item) in education.getItemList().enumerated(){
            typeName[item.rawValue] = (item,index)
        }

    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return education.getItemList().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AddItemCell.identity(), for: indexPath) as! AddItemCell
        currentType = education.getItemList()[indexPath.row]
        cell.mode = (currentType.rawValue,education.getItemByType(type: currentType))
        cell.textFiled.delegate = self
        return cell
    
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AddItemCell.cellHeight()
    }


   
}

extension add_educations{
    
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
}

// pciker

extension add_educations: itemPickerDelegate{
    func quitPickerView(_ picker: UIPickerView) {
        self.hiddenBackGround()
        
    }
    
    func changeItemValue(_ picker: UIPickerView, value: String, position: [Int : Int]) {
        
           education.changeValue(pinfoType: currentType, value: value)
           pickPosition[currentType] = position
           self.tableView.reloadRows(at: [IndexPath.init(row: currentRow, section: 0)], with: .none)
           self.hiddenBackGround()
    }
    
    
}
//save

extension add_educations{
    
    @objc func save(){
       
        let res:(Bool,String) = education.isValidate()
        if res.0{
            //
              pManager.educationInfos.append(education)
              self.navigationController?.popViewController(animated: true)
              self.delegate?.refreshDataByType(.education)
            
            
        }else{
              //
              self.navigationController?.view.addSubview(backgroundView)
              backgroundView.isUserInteractionEnabled = false
              self.navigationController?.navigationBar.isUserInteractionEnabled = false
              SVProgressHUD.show(UIImage.init(named: "error")!, status: "请检查输入")
              SVProgressHUD.dismiss(withDelay: 3, completion: {  [unowned self] in
                self.navigationController?.view.willRemoveSubview(self.backgroundView)
                self.backgroundView.removeFromSuperview()
                self.backgroundView.isUserInteractionEnabled = true
                self.navigationController?.navigationBar.isUserInteractionEnabled = true

            })
            
        }
        
    }
}


extension add_educations: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let currentName = textField.placeholder!
       
        //  pickerview 不显示键盘，记录当前的row和type
        switch  currentName {
            
        case "学位":
            pickView.mode = ("学位", selected.getItems(name: "学位")!)
            pickView.setPosition(position: pickPosition[.degree])
            showPickView()
            currentType = (typeName[currentName]?.0)!
            currentRow = (typeName[currentName]?.1)!
            return false
        case "开始时间":
            pickView.mode = ("生日", selected.getItems(name: "生日")!)
            pickView.setPosition(position: pickPosition[.startTime])
            showPickView()
            currentType = (typeName[currentName]?.0)!
            currentRow = (typeName[currentName]?.1)!
            return false
        case "结束时间":
            pickView.mode = ("生日", selected.getItems(name: "生日")!)
            pickView.setPosition(position: pickPosition[.endTime])
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
        
         if textField.placeholder == "专业" ||  textField.placeholder == "学校" || textField.placeholder == "城市"{
            education.changeValue(pinfoType: currentType, value: textField.text!)
            self.tableView.reloadRows(at: [IndexPath.init(row: currentRow, section: 0)], with: .none)
            
        }
        
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
