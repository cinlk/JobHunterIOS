//
//  evaluateSelfVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/16.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let placeHolder:String = "个人评价，500字以内"
fileprivate let limitWords:Int = 500

class evaluateSelfVC: BaseActionResumeVC {


    internal var section:Int = 0
    
 
    private  lazy var content:String = pManager.getEstimate()
    
    weak var delegate:modifyItemDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改个人评价"
        self.tableView.tableFooterView = UIView.init()
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.isScrollEnabled = false
        self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .plain, target: self, action: #selector(save))
        
        self.tableView.register(textViewCell.self, forCellReuseIdentifier: textViewCell.identity())
        
        
         NotificationCenter.default.addObserver(self, selector: #selector(editStatus), name: NSNotification.Name.init(addResumeInfoNotify), object: nil)
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
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
         cell.updateText = { content in
            self.isChange = true 
            self.content = content
            self.tableView.reloadData()
            
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
    
    @objc func save(){
        isChange = false
        
        self.view.endEditing(true)
        pManager.setEstimate(text:content)
        self.delegate?.modifiedItem(indexPath: IndexPath.init(row: 0, section: self.section))
        self.navigationController?.popvc(animated: true)
        
    }
}

