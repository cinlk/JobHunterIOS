//
//  modify_education.swift
//  internals
//
//  Created by ke.liang on 2018/2/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol educationModifyDelegate: class {
    
    func refreshModifiedData(index:Int, name:String)
    func refreshNewData()
}

class modifyitemView: UIViewController {

    
    private lazy var table:UITableView = {
        let tb = UITableView.init(frame: CGRect.zero)
        tb.tableFooterView = UIView.init()
        tb.delegate = self
        tb.dataSource = self
        tb.separatorStyle = .singleLine
        tb.showsHorizontalScrollIndicator = false
        tb.register(singleButtonCell.self, forCellReuseIdentifier: singleButtonCell.identity())
        tb.register(modify_educationCell.self, forCellReuseIdentifier: modify_educationCell.identity())
         return tb
        
    }()
    
    
    private lazy var backgroundView:UIView = { [unowned self] in
        let v = UIView.init(frame: self.view.bounds)
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

    private var pManager:personModelManager = personModelManager.shared
    
    private var selected:SelectItemUtil = SelectItemUtil.shared
    
    private var pickPosition:[personBaseInfo:[Int:Int]] = [:]

    
    private var count = 0
    private var type:resumeViewType = .baseInfo
    private var row:Int = 0
    private var currentRow:Int = 0
    weak var delegate:educationModifyDelegate?
    
    private var infosDict:Dictionary<resumeViewType,[Any]> = [:]
    
    var mode:(viewType:resumeViewType, row:Int)?{
        didSet{
            
            self.type = mode!.viewType
            self.row = mode!.row
            
            switch mode!.viewType {
            case .education:
                //infosDict[.education] = pManager.educationInfos
                self.count = pManager.educationInfos[mode!.row].getItemList().count + 1
                
            
            case .project:
                self.count = pManager.projectInfo[mode!.row].getItemList().count + 1
            case .skill:
                self.count = pManager.skillInfos[mode!.row].getItemList().count + 1
                
            default:
                break
            }
            pickPosition = [:]
            self.table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.addSubview(table)
        self.table.backgroundColor = UIColor.lightGray
        self.pickViewOriginXY = pickView.origin
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .plain, target: self, action: #selector(save))
        
        
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
    }
    

}

extension modifyitemView: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if count - 1 == indexPath.row{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: singleButtonCell.identity(), for: indexPath) as! singleButtonCell
            cell.btnType = .delete
            cell.deleteItem = self.deleteItem
            
            return cell
            
        }else{
        
            switch self.type{
            case .education:
                let cell = tableView.dequeueReusableCell(withIdentifier: modify_educationCell.identity(), for: indexPath) as! modify_educationCell
                
                let itemType = pManager.educationInfos[row].getItemList()[indexPath.row]
                
                cell.mode = (viewType:self.type, InfoType:itemType, row:row)
                cell.delegate = self
                
                return cell
            case .project:
                let cell = tableView.dequeueReusableCell(withIdentifier: modify_educationCell.identity(), for: indexPath) as! modify_educationCell
                let itemType = pManager.projectInfo[row].getItemList()[indexPath.row]
                cell.mode = (viewType:self.type, InfoType:itemType, row:row)
                cell.delegate = self
                cell.describeText.delegate = self
                return cell
            case .skill:
                let cell = tableView.dequeueReusableCell(withIdentifier: modify_educationCell.identity(), for: indexPath) as! modify_educationCell
                let itemType = pManager.skillInfos[row].getItemList()[indexPath.row]
                cell.mode = (viewType:self.type, InfoType:itemType, row:row)
                cell.delegate = self
                cell.describeText.delegate = self
                return cell
            default:
                break
            
            }

        }
        return UITableViewCell.init()
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if count - 1 == indexPath.row{
           return singleButtonCell.cellHeight()
        }else{
            switch self.type{
            case .education:
                return 45
            case .project:
                if indexPath.row == count - 2{
                    return 160
                }
                
            case .skill:
                if indexPath.row == count - 2 {
                    return 200
                }
                
            default:
                break
            }
        
        }
        return 45
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if count - 1 == indexPath.row{
            return
        }
        
        currentRow = indexPath.row
        
        switch self.type {
        
        case .education:
            let item = pManager.educationInfos[row].getItemList()[indexPath.row]
            switch item{
            case .startTime, .endTime:
                // 需要用生日！！！
                pickView.mode = ("生日", selected.getItems(name: "生日")!)
                pickView.setPosition(position: pickPosition[item])
                showPickView()
            case .degree:
                pickView.mode = (item.rawValue, selected.getItems(name: item.rawValue)!)
                pickView.setPosition(position: pickPosition[item])
                showPickView()
            default:
                break
                
            }
        case .project:
            let item = pManager.projectInfo[row].getItemList()[indexPath.row]
            switch item{
            case  .startTime, .endTime:
                pickView.mode = ("生日", selected.getItems(name: "生日")!)
                pickView.setPosition(position: pickPosition[item])
                showPickView()
            default:
                break
            }
        case .skill:
            let item = pManager.skillInfos[row].getItemList()[indexPath.row]
            switch item{
            case .skill:
                pickView.mode = ("技能", selected.getItems(name: "技能")!)
                pickView.setPosition(position: pickPosition[item])
                showPickView()
            default:
                break
            }
            
            
        default:
            break
        }
    }
    
    
}

extension modifyitemView{
    
    @objc private func hiddenBackGround(){
        self.navigationController?.view.willRemoveSubview(backgroundView)
        backgroundView.removeFromSuperview()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.pickView.origin = self.pickViewOriginXY
            
        }) { (bool) in
            
        }
        
    }
    
    private func showPickView(){
        self.navigationController?.view.addSubview(backgroundView)
        // 取消编辑状态
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.3, animations: {
            self.pickView.frame = CGRect.init(x: 0, y: ScreenH - 200, width: ScreenW, height: 200)
        }, completion: { (bool) in
            
        })
    }
}

extension modifyitemView: itemPickerDelegate{
    
    func quitPickerView(_ picker: UIPickerView) {
        self.hiddenBackGround()
        
    }
    
    func changeItemValue(_ picker: UIPickerView, value: String, position: [Int : Int]) {
        switch  self.type {
        case .education:
            let item = pManager.educationInfos[row].getItemList()[currentRow]
            pManager.educationInfos[row].changeValue(pinfoType: item, value: value)
            pickPosition[item] = position
        case .project:
            let item = pManager.projectInfo[row].getItemList()[currentRow]
            pManager.projectInfo[row].changeValue(pinfoType: item, value: value)
            pickPosition[item] = position
        case .skill:
            let item = pManager.skillInfos[row].getItemList()[currentRow]
            pManager.skillInfos[row].changeValue(pinfoType: item, value: value)
            pickPosition[item] = position
            
        default:
            break
        }
    
        self.table.reloadRows(at: [IndexPath.init(row: currentRow, section: 0)], with: .none)
        self.hiddenBackGround()
        
    }
    
    
}


extension modifyitemView {
    
    @objc func save(){
        
        self.view.endEditing(true)
        SVProgressHUD.show(#imageLiteral(resourceName: "checkmark"), status: "保存成功")
        SVProgressHUD.dismiss(withDelay: 2) {
            self.navigationController?.popViewController(animated: true)
            self.delegate?.refreshModifiedData(index: self.row, name: self.type.rawValue)
        }
    }
    
    func deleteItem(){
        //MARK 提示
        //pManager.delete(type: .education, index: self.index)
        switch  self.type {
        case .education:
             pManager.educationInfos.remove(at: self.row)
        case .project:
            pManager.projectInfo.remove(at: self.row)
        case .skill:
            pManager.skillInfos.remove(at: self.row)
        default:
            break
        }
       
        
        // delegate主界面删除section 数据
        SVProgressHUD.show(#imageLiteral(resourceName: "checkmark"), status: "删除成功")
        SVProgressHUD.dismiss(withDelay: 2) {
            self.navigationController?.popViewController(animated: true)
            self.delegate?.refreshNewData()
        }
        
    }
    
}

extension modifyitemView: changeDataDelegate{
    
    func changeEducationInfo(viewType: resumeViewType, type: personBaseInfo, row: Int, value: String) {
        switch viewType {
            
        case .education:
            pManager.educationInfos[row].changeValue(pinfoType: type, value: value)
           
        case .project:
            pManager.projectInfo[row].changeValue(pinfoType: type, value: value)
        case .skill:
            pManager.skillInfos[row].changeValue(pinfoType: type, value: value)
            break
        default:
            break
        }
        
         self.table.reloadData()
    }
    
    
    func changeBaseInfo(type: personBaseInfo, value: String) {
        
    }
    
}



extension modifyitemView: UITextViewDelegate{
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let frame:CGRect = textView.frame
        
        let offset:CGFloat = frame.origin.y + frame.height  -  (ScreenH -  KEYBOARD_HEIGHT)
        UIView.animate(withDuration: 0.3) {
            if offset > 0  {
                self.view.frame = CGRect.init(x: 0, y: -offset, width: ScreenW, height: ScreenH)
            }
        }
        
        
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3) {
             self.view.frame = CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH)
        }
        switch self.type {
        case .project:
            pManager.projectInfo[row].changeValue(pinfoType: .describe, value: textView.text)
        case .skill:
            pManager.skillInfos[row].changeValue(pinfoType: .describe, value: textView.text)
            break
        default:
            break
        }
       
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n"{
//            textView.resignFirstResponder()
//            return false
//        }
//        if range.location >= 600 {
//            SVProgressHUD.showError(withStatus: "超过字数限制")
//            return false
//        }
        return true
    }
    
    
    
}

