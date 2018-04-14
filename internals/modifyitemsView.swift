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


// 添加
protocol addResumeItenDelegate: class {
    
    func addNewItem(type:resumeViewType)
    
}

class modifyitemView: UIViewController {

    
    private lazy var table:UITableView = {
        let tb = UITableView.init(frame: CGRect.zero)
        tb.tableFooterView = UIView.init()
        tb.delegate = self
        tb.dataSource = self
        tb.backgroundColor = UIColor.viewBackColor()
        tb.separatorStyle = .singleLine
        tb.showsHorizontalScrollIndicator = false
        tb.register(singleButtonCell.self, forCellReuseIdentifier: singleButtonCell.identity())
        tb.register(modify_ResumeItemCell.self, forCellReuseIdentifier: modify_ResumeItemCell.identity())
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
    
    private var pickPosition:[ResumeInfoType:[Int:Int]] = [:]

    
    private var count = 0
    private var type:resumeViewType = .baseInfo
    private var row:Int = 0
    private var currentRow:Int = 0
    weak var delegate:modifyItemDelegate?
    
    // eatch row
   
    
    private var infosDict:Dictionary<resumeViewType,[Any]> = [:]
    
    var mode:(viewType:resumeViewType, indexPath:IndexPath)?{
        didSet{
            
            self.type = mode!.viewType
            self.row = mode!.indexPath.row
            
            switch mode!.viewType {
            case .education:
                self.count = (pManager.mode?.educationInfo[self.row].getItemList().count ?? 0)  + 1
            case .intern:
                self.count = (pManager.mode?.internInfo[self.row].getItemList().count ?? 0)  + 1
            case .skill:
                self.count = (pManager.mode?.skills[self.row].getItemList().count ?? 0) + 1
                
            default:
                break
            }
            pickPosition = [:]
            self.table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickViewOriginXY = pickView.origin
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .plain, target: self, action: #selector(save))
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "修改" + self.type.rawValue
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.navigationItem.title = ""
        pickView.removeFromSuperview()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.addSubview(table)
        
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
            let cell = tableView.dequeueReusableCell(withIdentifier: modify_ResumeItemCell.identity(), for: indexPath) as! modify_ResumeItemCell
            // 具体的简历元素类型
            var itemType:ResumeInfoType?
            
            switch self.type{
            case .education:
                 guard let item = pManager.mode?.educationInfo[row]  else { return UITableViewCell() }
                 //ceducationRow = indexPath.row
                 itemType = item.getItemList()[indexPath.row]
                 cell.mode = (viewType:self.type, InfoType: itemType!, item: item)
             case .intern:
                guard let item = pManager.mode?.internInfo[row]  else { return UITableViewCell() }
                //cInternRow = indexPath.row
                itemType = item.getItemList()[indexPath.row]
                cell.mode = (viewType:self.type, InfoType: itemType!, item: item)

             case .skill:
                guard let item = pManager.mode?.skills[row]  else { return UITableViewCell() }
                //cSkillRow = indexPath.row
                itemType = item.getItemList()[indexPath.row]
                cell.mode = (viewType:self.type, InfoType: itemType!, item: item)

             default:
                return UITableViewCell.init()
            
            }
            
           
            cell.delegate = self
            // textView的代理
            cell.describeText.delegate = self 
            return cell

        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if count - 1 == indexPath.row{
           return singleButtonCell.cellHeight()
        }else{
            switch self.type{
            case .education:
                return 45
            case .intern:
                if indexPath.row == count - 2{
                    return 200
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
            guard let item = pManager.mode?.educationInfo[row] else { return }
            let type = item.getItemList()[indexPath.row]
            switch type{
            case .startTime, .endTime:
                // 需要用生日！！！
                pickView.mode = ("生日", selected.getItems(name: "生日")!)
                pickView.setPosition(position: pickPosition[type])
                showPickView()
            case .degree:
                pickView.mode = (type.rawValue, selected.getItems(name: type.rawValue)!)
                pickView.setPosition(position: pickPosition[type])
                showPickView()
            default:
                break
                
            }
        case .intern:
            guard let item = pManager.mode?.internInfo[row] else { return }
            let type = item.getItemList()[indexPath.row]
            switch type{
            case  .startTime, .endTime:
                pickView.mode = ("生日", selected.getItems(name: "生日")!)
                pickView.setPosition(position: pickPosition[type])
                showPickView()
            default:
                break
            }
        case .skill:
            guard let item = pManager.mode?.skills[row] else { return }
            let type = item.getItemList()[indexPath.row]
            switch type{
            case .skill:
                pickView.mode = ("技能", selected.getItems(name: "技能")!)
                pickView.setPosition(position: pickPosition[type])
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
    
    // 改变对应值 和 更新pick的位置
    func changeItemValue(_ picker: UIPickerView, value: String, position: [Int : Int]) {
        switch  self.type {
        case .education:
            guard let mode = pManager.mode?.educationInfo[row] else { return }
            let type = mode.getItemList()[currentRow]
            mode.changeValue(type: type, value: value)
            pickPosition[type] = position
        case .intern:
            guard let mode = pManager.mode?.internInfo[row] else { return }
            let type = mode.getItemList()[currentRow]
            mode.changeValue(type: type, value: value)
            pickPosition[type] = position
        case .skill:
            guard let mode = pManager.mode?.skills[row] else { return }
            let type = mode.getItemList()[currentRow]
            mode.changeValue(type: type, value: value)
            pickPosition[type] = position
            
        default:
            break
        }
    
        self.table.reloadRows(at: [IndexPath.init(row: currentRow, section: 0)], with: .none)
        self.hiddenBackGround()
        
    }
    
    
}


extension modifyitemView {
    
    private func setStatus(name:String){
        
        //self.navigationController?.view.addSubview(backgroundView)
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        //self.view.isUserInteractionEnabled = false
        //self.backgroundView.isUserInteractionEnabled = false
        let indexPath = IndexPath.init(row: self.mode!.indexPath.row + 1, section:self.mode!.indexPath.section)
        
        
        // 修改
        let hub = MBProgressHUD.showAdded(to: self.table, animated: true)
        hub.mode = .customView
        hub.customView = UIImageView.init(image: #imageLiteral(resourceName: "checkmark").changesize(size: CGSize.init(width: 25, height: 25)))
        hub.label.text = name + "成功"
        hub.margin = 10
        hub.label.textColor = UIColor.white
        hub.bezelView.backgroundColor = UIColor.backAlphaColor()
        hub.removeFromSuperViewOnHide = true
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            if name == "保存"{
                self.delegate?.modifiedItem(indexPath: indexPath)
            }else{
                self.delegate?.deleteItem(indexPath: indexPath)
            }
            self.navigationController?.navigationBar.isUserInteractionEnabled = true
            hub.hide(animated: true)
            self.navigationController?.popViewController(animated: true)

        }
    }
            
    @objc func save(){
        
        // 判断数据
        
        self.view.endEditing(true)
        setStatus(name:"保存")
        
    }
    
    func deleteItem(){
        //MARK 提示
        //pManager.delete(type: .education, index: self.index)
        switch  self.type {
        case .education:
             pManager.mode?.educationInfo.remove(at: self.row)
        case .intern:
             pManager.mode?.internInfo.remove(at: self.row)
        case .skill:
            pManager.mode?.skills.remove(at: self.row)
        default:
            break
        }
       
        // delegate主界面删除section 数据
        setStatus(name:"删除")
        
    }
    
}

extension modifyitemView: changeDataDelegate{
    // 改变某item的值
    func changeOtherInfo(viewType: resumeViewType, type: ResumeInfoType, value: String) {
        switch viewType {
            case .education:
                    print(type,value)
                    pManager.mode?.educationInfo[row].changeValue(type: type, value: value)
            case .intern:
                    pManager.mode?.internInfo[row].changeValue(type: type, value: value)
            case .skill:
                    pManager.mode?.skills[row].changeValue(type: type, value: value)
                    break
            default:
                    break
            }
        
        self.table.reloadData()
    }
    
    
    func changeBasicInfo(type: ResumeInfoType, value: String) {
        
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
        let cell = table.cellForRow(at: IndexPath.init(row: count - 1, section: 0))
        let frame:CGRect = (cell?.frame)!
        let offset:CGFloat = frame.origin.y + 120  -  (ScreenH -  KEYBOARD_HEIGHT - 35 )
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
        case .intern:
            pManager.mode?.internInfo[row].changeValue(type: .describe, value: textView.text)
        case .skill:
            pManager.mode?.skills[row].changeValue(type: .describe, value: textView.text)
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

