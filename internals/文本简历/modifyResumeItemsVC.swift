//
//  modify_education.swift
//  internals
//
//  Created by ke.liang on 2018/2/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// 修改和删除
protocol modifyItemDelegate: class {
    
    func modifiedItem(indexPath:IndexPath, type:ResumeSubItems, mode:Any?)
    func deleteItem(indexPath: IndexPath, type:ResumeSubItems)
}





class modifyResumeItemVC: BaseActionResumeVC {
    
    
    private lazy var dispose:DisposeBag = DisposeBag.init()
    private lazy var vm:PersonViewModel = PersonViewModel.shared
    
    
    // 修改的行数
    private var modifyIndexPath:IndexPath?
    
    weak var delegate:modifyItemDelegate?
    
   
    private var placeholdStr:String = ""
    private var id:String = ""
    
    private lazy var barBtn:UIBarButtonItem =  UIBarButtonItem.init(title: "保存", style: .plain, target: nil, action: nil)
    
    
    
    var mode:(viewType:ResumeSubItems, indexPath:IndexPath, data:Any, resumeId:String)?{
        didSet{
            
            guard  let mode = mode else {
                return
            }
            
            self.modifyIndexPath = mode.indexPath
            
            self.title =  "修改" + self.mode!.viewType.describe
            switch mode.viewType {
            case .education:
                
                if let data = mode.data as? educationInfoTextResume{
                     setData(data)
                }
            
            case .works:
                 if let data = mode.data as? workInfoTextResume{
                    setData(data)
                }
            case .project:
                if let data = mode.data as? ProjectInfoTextResume{
                    setData(data)
                }
            
            case .schoolWork:
                if let data = mode.data as? CollegeActivityTextResume{
                    setData(data)
                }
            case .practice:
                if let data = mode.data as? SocialPracticeTextResume{
                    setData(data)
                }
            case .other:
                if let data = mode.data as? OtherTextResume{
                    setData(data)
                }
            case .skills:
                if let data = mode.data as? SkillsTextResume{
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
        setView()
        setViewModel()
        
       
        
        //NotificationCenter.default.addObserver(self, selector: #selector(editStatus), name: NotificationName.addResumSubItem, object: nil)
        
    }
    
    deinit {
        //NotificationCenter.default.removeObserver(self)
        print("deinit modifyResumeItemVC \(self)")
    }
    
    override func currentViewControllerShouldPop() -> Bool {
        
        
        if self.isEdit{
            let alertController = UIAlertController(title: nil, message: "编辑尚未结束，确定返回吗？", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "继续编辑", style: .default) { (_) in
                
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
            let alertAction = UIAlertAction(title: "保存并返回", style: .default) { [weak self] (_) in
                self?.save()
            }
            alertController.addAction(alertAction)
            let cancelAction = UIAlertAction(title: "放弃保存", style: .cancel) { [weak self] (_) in
                self?.navigationController?.popvc(animated: true)
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
        }
        
        return true 
 
        
    }


}



extension modifyResumeItemVC{
    
    private func setView(){
        self.navigationItem.rightBarButtonItem = barBtn
        tableView.tableFooterView = UIView.init()
        tableView.bounces = false
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = UIColor.viewBackColor()
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(singleButtonCell.self, forCellReuseIdentifier: singleButtonCell.identity())
        tableView.register(AddItemCell.self, forCellReuseIdentifier: AddItemCell.identity())
        tableView.register(textViewCell.self, forCellReuseIdentifier: textViewCell.identity())
        
    }
    
    private func setViewModel(){
        barBtn.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.save()
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        NotificationCenter.default.rx.notification(NotificationName.addResumSubItem, object: nil).subscribe(onNext: { [weak self] (notify) in
            self?.editStatus(notify)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
    }
    private func setData(_ data:reumseInfoAction){
        guard let kv = data.getTypeValue() else {
            return
        }
        diction = kv
        keys = data.getItemList()
        onlyPickerResumeType = data.getPickerResumeType()
        placeholdStr = data.placeHolder
        id = data.getId
        
    }
}

extension modifyResumeItemVC{
    
    
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
            
            cell.deleteItem = { [weak self] in
                self?.deleteItem()
            }
            
            return cell
            
        }else if keys.count - 1 == indexPath.row{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: textViewCell.identity(), for: indexPath) as! textViewCell
            
            cell.textView.text = diction[.describe]
            cell.updateText = { [weak self] value in
                self?.isChange = true
                self?.diction[.describe] =  value
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
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

extension modifyResumeItemVC: AddItemCellUpdate{
    
    func updateTextfield(value: String, type: ResumeInfoType){
        if diction[type] == value{
            return
        }
        
        diction[type] = value
        print(value)
        isChange = true 
        self.tableView.reloadRows(at: [IndexPath.init(row: keys.firstIndex(of: type)!, section: 0)], with: .automatic)
    }

}



extension modifyResumeItemVC {
    
    @objc func save(){
        if super.checkValue() == false{
            return
        }
    
        // 判断数据
        guard  let indexPath = modifyIndexPath, let mode = mode else {
            return
        }
        res["resumeId"] = mode.resumeId
        
        switch mode.viewType {
        case .education:
            
            self.vm.updateTextResumeEducation(id: id, req: TextResumeEducationReq.init(dict: res)).subscribe(onNext: { [weak self] (res) in
                guard let `self` = self else{
                    return
                }
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    
                    self.res["id"] = self.id
                    //let row = indexPath.row
                    //pManager.modifyItemBy(type: mode.viewType, row: row, res: res)
                    self.delegate?.modifiedItem(indexPath: indexPath, type: mode.viewType, mode: educationInfoTextResume.init(JSON: self.res))
                    self.navigationController?.popvc(animated: true)
                    
                }else{
                    
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        case .works:
            
            self.vm.updateResumeWork(id: id, req: TextResumeWorkReq.init(dict: res)).subscribe(onNext: { [weak self] (res) in
                guard let `self` = self else{
                    return
                }
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    
                    self.res["id"] = self.id
                    //let row = indexPath.row
                    //pManager.modifyItemBy(type: mode.viewType, row: row, res: res)
                    self.delegate?.modifiedItem(indexPath: indexPath, type: mode.viewType, mode: workInfoTextResume.init(JSON: self.res))
                    self.navigationController?.popvc(animated: true)
                    
                }else{
                    
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
        case .project:
            
            self.vm.updateResumeProject(id: id, req: TextResumeProjectReq.init(dict: res)).subscribe(onNext: { [weak self] (res) in
                guard let `self` = self else{
                    return
                }
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    
                    self.res["id"] = self.id
                    //let row = indexPath.row
                    //pManager.modifyItemBy(type: mode.viewType, row: row, res: res)
                    self.delegate?.modifiedItem(indexPath: indexPath, type: mode.viewType, mode: ProjectInfoTextResume.init(JSON: self.res))
                    self.navigationController?.popvc(animated: true)
                    
                }else{
                    
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
        case .schoolWork:
            self.vm.updateResumeCollegeActive(id: id, req: TextResumeCollegeActiveReq.init(dict: res)).subscribe(onNext: { [weak self] (res) in
                guard let `self` = self else{
                    return
                }
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    
                    self.res["id"] = self.id
                    //let row = indexPath.row
                    //pManager.modifyItemBy(type: mode.viewType, row: row, res: res)
                    self.delegate?.modifiedItem(indexPath: indexPath, type: mode.viewType, mode: CollegeActivityTextResume.init(JSON: self.res))
                    self.navigationController?.popvc(animated: true)
                    
                }else{
                    
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
        case .practice:
            
            self.vm.updateResumeSocialPractice(id: id, req: TextResumeSocialPracticeReq.init(dict: res)).subscribe(onNext: { [weak self] (res) in
                guard let `self` = self else{
                    return
                }
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    
                    self.res["id"] = self.id
                    //let row = indexPath.row
                    //pManager.modifyItemBy(type: mode.viewType, row: row, res: res)
                    self.delegate?.modifiedItem(indexPath: indexPath, type: mode.viewType, mode: SocialPracticeTextResume.init(JSON: self.res))
                    self.navigationController?.popvc(animated: true)
                    
                }else{
                    
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
        case .skills:
            self.vm.updateResumeSkill(id: id, req: TextResumeSkillReq.init(dict: res)).subscribe(onNext: { [weak self] (res) in
                guard let `self` = self else{
                    return
                }
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    
                    self.res["id"] = self.id
                    //let row = indexPath.row
                    //pManager.modifyItemBy(type: mode.viewType, row: row, res: res)
                    self.delegate?.modifiedItem(indexPath: indexPath, type: mode.viewType, mode: SkillsTextResume.init(JSON: self.res))
                    self.navigationController?.popvc(animated: true)
                    
                }else{
                    
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
        case .other:
            
            self.vm.updateResumeOther(id: id, req: TextResumeOtherReq.init(dict: res)).subscribe(onNext: { [weak self] (res) in
                guard let `self` = self else{
                    return
                }
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    
                    self.res["id"] = self.id
                    //let row = indexPath.row
                    //pManager.modifyItemBy(type: mode.viewType, row: row, res: res)
                    self.delegate?.modifiedItem(indexPath: indexPath, type: mode.viewType, mode: OtherTextResume.init(JSON: self.res))
                    self.navigationController?.popvc(animated: true)
                    
                }else{
                    }
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
            
        default:
            break
        }
        
        

    }
    
    func deleteItem(){
        
        self.view.endEditing(true)
        
        
        guard  let indexPath = modifyIndexPath, let mode = mode  else {
            return
        }
        
        switch mode.viewType {
        case .education:
            self.vm.deleteTextResumeEducation(resumeId: mode.resumeId, id: id).subscribe(onNext: { [weak self] (res) in
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    self?.delegate?.deleteItem(indexPath: indexPath, type: mode.viewType)
                    self?.navigationController?.popvc(animated: true)
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        case .works:
            self.vm.deleteResumeWork(resumeId: mode.resumeId, id: id).subscribe(onNext: { [weak self] (res) in
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    self?.delegate?.deleteItem(indexPath: indexPath, type: mode.viewType)
                    self?.navigationController?.popvc(animated: true)
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        case .project:
            self.vm.deleteResumeProject(resumeId: mode.resumeId, id: id).subscribe(onNext: { [weak self] (res) in
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    self?.delegate?.deleteItem(indexPath: indexPath, type: mode.viewType)
                    self?.navigationController?.popvc(animated: true)
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        case .schoolWork:
            self.vm.deleteResumeCollegeActive(resumeId: mode.resumeId, id: id).subscribe(onNext: { [weak self] (res) in
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    self?.delegate?.deleteItem(indexPath: indexPath, type: mode.viewType)
                    self?.navigationController?.popvc(animated: true)
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        case .practice:
            self.vm.deleteResumeSocialPractice(resumeId: mode.resumeId, id: id).subscribe(onNext: { [weak self] (res) in
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    self?.delegate?.deleteItem(indexPath: indexPath, type: mode.viewType)
                    self?.navigationController?.popvc(animated: true)
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
        case .skills:
            self.vm.deleteResumeSkill(resumeId: mode.resumeId, id: id).subscribe(onNext: { [weak self] (res) in
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    self?.delegate?.deleteItem(indexPath: indexPath, type: mode.viewType)
                    self?.navigationController?.popvc(animated: true)
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
        case .other:
            self.vm.deleteResumeOther(resumeId: mode.resumeId, id: id).subscribe(onNext: { [weak self] (res) in
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    self?.delegate?.deleteItem(indexPath: indexPath, type: mode.viewType)
                    self?.navigationController?.popvc(animated: true)
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
        default:
            break
        }
        
        
        //let row = indexPath.row
        //pManager.deleteItemBy(type: mode.viewType, row: row)
        //self.delegate?.deleteItem(indexPath: indexPath)
        
//        self.navigationController?.popvc(animated: true)

    }
    
}




