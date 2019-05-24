//
//  evaluateSelfVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/16.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


fileprivate let placeHolder:String = "个人评价，500字以内"
fileprivate let limitWords:Int = 500

class evaluateSelfVC: BaseActionResumeVC {

    private lazy var vm:PersonViewModel = PersonViewModel.shared
    private lazy var dispose:DisposeBag = DisposeBag.init()
    
    private var id:String = ""
    private var resumeId:String = ""
    
    
    private var section:Int = 0
    
    private var content:String = ""
    
    weak var delegate:modifyItemDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改个人评价"
        self.tableView.tableFooterView = UIView.init()
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.isScrollEnabled = false
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .plain, target: self, action: #selector(save))
        
        self.tableView.register(textViewCell.self, forCellReuseIdentifier: textViewCell.identity())
        
        NotificationCenter.default.rx.notification(NotificationName.addResumSubItem, object: nil).subscribe(onNext: { [weak self] (notify) in
            self?.editStatus(notify)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
         //NotificationCenter.default.addObserver(self, selector: #selector(editStatus), name: NotificationName.addResumSubItem, object: nil)
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
    
    
    deinit {
        //NotificationCenter.default.removeObserver(self)
        print("deinit evaludateSelfVc \(self)")
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: textViewCell.identity(), for: indexPath) as!
            textViewCell
         cell.updateText = { [weak self] content in
            self?.isChange = true
            self?.content = content
            self?.tableView.reloadData()
            
        }
        cell.placeHolderLabel.text = placeHolder
        cell.placeHolderLabel.isHidden = content.isEmpty ? false : true 
        cell.textView.text = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return textViewCell.cellHeight()
    }
    
    


}


extension evaluateSelfVC{
    
    
    internal func setData(id:String, resumeId:String, section:Int, content:String){
        self.id = id
        self.resumeId = resumeId
        self.section = section
        self.content = content
    }
    
    @objc func save(){
        isChange = false
        self.view.endEditing(true)
        self.vm.updateResumEstimate(id: self.id, req: TextResumeEstimateReq.init(dict: ["resumeId": self.resumeId, "content": self.content])).subscribe(onNext: { [weak self] (res) in
            guard let `self` = self else {
                return
            }
            if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                
                self.delegate?.modifiedItem(indexPath: IndexPath.init(row: 0, section: self.section), type: .selfEvaludate, mode: EstimateTextResume.init(JSON: ["id":self.id, "content": self.content]))
                
                self.navigationController?.popvc(animated: true)
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
    }
}

