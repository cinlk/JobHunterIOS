//
//  AddBaseInfoTableViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/20.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// 添加
protocol addResumeItenDelegate: class {
    
    func addNewItem(type:ResumeSubItems, mode:Any?)
    
}


//let addResumeInfoNotify:String = "addResumeInfoNotify"

class AddResumeItemSubItemViewController: BaseActionResumeVC {
    
    
    private lazy var dispose:DisposeBag = DisposeBag.init()
    private lazy var vm:PersonViewModel = PersonViewModel.shared
    
    
    internal var resumeId:String = ""
    internal var itemType:ResumeSubItems = .none{
        didSet{
            
            self.title = itemType.add
            switch itemType {
            case .education:
                if let data = educationInfoTextResume(JSON: [:]){
                    setData(data)
                }
            
            case .works:
                if let data = workInfoTextResume(JSON: [:]){
                    setData(data)
                }
                
            case .project:
                if let data = ProjectInfoTextResume(JSON: [:]){
                    setData(data)
                }

            case .schoolWork:
                if let data =  CollegeActivityTextResume(JSON: [:]){
                    setData(data)
                }
                
            case .practice:
                if let data = SocialPracticeTextResume(JSON: [:]){
                    setData(data)
                }
            case .other:
                if let data = OtherTextResume(JSON: [:]){
                    setData(data)
                }
            
            case .skills:
                if let data = SkillsTextResume(JSON: [:]){
                    setData(data)
                }
                
            default:
                break
            }
        }
    }
    
    
    internal var placeholder:String = "输入专业描述,500子以内"
    // 添加item代理
    weak var delegate:addResumeItenDelegate?
    
    
    private lazy var barBtn: UIBarButtonItem = UIBarButtonItem.init(title: "保存", style: .plain, target: nil, action: nil)
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setViews()
        setViewModel()
        
    }
    
    
    override func currentViewControllerShouldPop() -> Bool {
        
        
        if self.isEdit{
            let alertController = UIAlertController(title: nil, message: "编辑尚未结束，确定返回吗？", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "继续编辑", style: .default) {  (_) in
                
            }
            alertController.addAction(alertAction)
            let cancelAction = UIAlertAction(title: "放弃修改", style: .cancel) { [weak self] (_) in
                self?.navigationController?.popvc(animated: true)
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
            
        }
        
        // 未保存
        if self.isChange{
            
            let alertController = UIAlertController(title: nil, message: "修改尚未保存，确定返回吗？", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "保存并返回", style: .default) {  [weak self] (_) in
                self?.save()
            }
            alertController.addAction(alertAction)
            let cancelAction = UIAlertAction(title: "放弃保存", style: .cancel) {  [weak self] (_) in
                self?.navigationController?.popvc(animated: true)
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
        }
        
        return true

        

        
    }
    
    deinit {
        //NotificationCenter.default.removeObserver(self)
        print("deinit addResumeItemVC \(self)")
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
            // 输入描述的cell
            let cell = tableView.dequeueReusableCell(withIdentifier: textViewCell.identity(), for: indexPath) as! textViewCell
            
            cell.textView.text = diction[.describe]
            cell.updateText = { [weak self]  value in
                self?.isChange = true
                self?.diction[.describe] =  value
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
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


extension AddResumeItemSubItemViewController{
    
    private func setData(_ data:reumseInfoAction){
        guard  let kv = data.getTypeValue()  else {
            return
        }
        diction =  kv 
        keys = data.getItemList()
        onlyPickerResumeType = data.getPickerResumeType()
        placeholder = data.placeHolder
        
    }
    
    private  func save(){
        
        if super.checkValue() == false{
            return
        }
        res["resumeId"] = self.resumeId
        // 添加到服务器
        switch self.itemType {
        case .education:
            self.vm.createTextResumeEducation(req: TextResumeEducationReq.init(dict: res)).subscribe(onNext: { [weak self] (res) in
                guard let `self` = self else {
                    return
                }
                
                if  let id = res.body?.id {
                    self.res["id"] = id
                    self.delegate?.addNewItem(type: self.itemType, mode:  educationInfoTextResume.init(JSON: self.res))
                    self.navigationController?.popvc(animated: true)
                }else{
                    self.view.showToast(title: "创建失败", customImage: nil, mode: .text)
                }
                
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        case .works:
            self.vm.newResumeWorkInfo(req: TextResumeWorkReq.init(dict: res)).subscribe(onNext: { [weak self] (res) in
                guard let `self` = self else {
                    return
                }
                
                if  let id = res.body?.id {
                    self.res["id"] = id
                    self.delegate?.addNewItem(type: self.itemType, mode:  workInfoTextResume.init(JSON: self.res))
                    self.navigationController?.popvc(animated: true)
                }else{
                    self.view.showToast(title: "创建失败", customImage: nil, mode: .text)
                }
                
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        case .project:
            self.vm.newResumeProjectInfo(req: TextResumeProjectReq.init(dict: res)).subscribe(onNext: { [weak self] (res) in
                guard let `self` = self else {
                    return
                }
                
                if  let id = res.body?.id {
                    self.res["id"] = id
                    self.delegate?.addNewItem(type: self.itemType, mode:  ProjectInfoTextResume.init(JSON: self.res))
                    self.navigationController?.popvc(animated: true)
                }else{
                    self.view.showToast(title: "创建失败", customImage: nil, mode: .text)
                }
                
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
        case .schoolWork:
            self.vm.newResumeCollegeActiveInfo(req: TextResumeCollegeActiveReq.init(dict: res)).subscribe(onNext: { [weak self] (res) in
                guard let `self` = self else {
                    return
                }
                
                if  let id = res.body?.id {
                    self.res["id"] = id
                    self.delegate?.addNewItem(type: self.itemType, mode:  CollegeActivityTextResume.init(JSON: self.res))
                    self.navigationController?.popvc(animated: true)
                }else{
                    self.view.showToast(title: "创建失败", customImage: nil, mode: .text)
                }
                
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
        case .practice:
            self.vm.newResumeSocialPracticeInfo(req: TextResumeSocialPracticeReq.init(dict: res)).subscribe(onNext: { [weak self] (res) in
                guard let `self` = self else {
                    return
                }
                
                if  let id = res.body?.id {
                    self.res["id"] = id
                    self.delegate?.addNewItem(type: self.itemType, mode:  SocialPracticeTextResume.init(JSON: self.res))
                    self.navigationController?.popvc(animated: true)
                }else{
                    self.view.showToast(title: "创建失败", customImage: nil, mode: .text)
                }
                
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        case .skills:
            
            self.vm.newResumeSkillInfo(req: TextResumeSkillReq.init(dict: res)).subscribe(onNext: { [weak self] (res) in
                guard let `self` = self else {
                    return
                }
                
                if  let id = res.body?.id {
                    self.res["id"] = id
                    self.delegate?.addNewItem(type: self.itemType, mode:  SkillsTextResume.init(JSON: self.res))
                    self.navigationController?.popvc(animated: true)
                }else{
                    self.view.showToast(title: "创建失败", customImage: nil, mode: .text)
                }
                
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
        case .other:
            self.vm.newResumeOtherInfo(req: TextResumeOtherReq.init(dict: res)).subscribe(onNext: { [weak self] (res) in
                guard let `self` = self else {
                    return
                }
                
                if  let id = res.body?.id {
                    self.res["id"] = id
                    self.delegate?.addNewItem(type: self.itemType, mode:  OtherTextResume.init(JSON: self.res))
                    self.navigationController?.popvc(animated: true)
                }else{
                    self.view.showToast(title: "创建失败", customImage: nil, mode: .text)
                }
                
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        default:
            break
        }
       // pManager.addItemBy(itemType: itemType, res: res)
        
        //delegate?.addNewItem(type: itemType)
        //self.navigationController?.popvc(animated: true)
        
    }
    
}

extension AddResumeItemSubItemViewController{
    private func setViews(){
        
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.bounces = false
        self.tableView.tableFooterView = UIView.init()
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.navigationItem.rightBarButtonItem = barBtn
        self.tableView.register(AddItemCell.self, forCellReuseIdentifier: AddItemCell.identity())
        self.tableView.register(textViewCell.self, forCellReuseIdentifier: textViewCell.identity())
        
//        NotificationCenter.default.addObserver(self, selector: #selector(editStatus), name: NSNotification.Name.init(addResumeInfoNotify), object: nil)
    }
    
    private func setViewModel(){
        
        barBtn.rx.tap.asDriver().drive(onNext: { [weak self] in
                self?.save()
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        NotificationCenter.default.rx.notification(NotificationName.addResumSubItem, object: nil).subscribe(onNext: { [weak self] (notify) in
            self?.editStatus(notify)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
    }
}

// pciker

extension AddResumeItemSubItemViewController: AddItemCellUpdate{
    
 
    func updateTextfield(value: String, type: ResumeInfoType){
        if diction[type]  == value{
            return
        }
        
        diction[type] = value
        isChange = true 
        self.tableView.reloadRows(at: [IndexPath.init(row: keys.firstIndex(of: type)!, section: 0)], with: .automatic)
     }

}





