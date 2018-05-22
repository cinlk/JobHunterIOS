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

class evaluateSelfVC: UITableViewController {


    internal var section:Int = 0
    
    private var  cacheCell:textViewCell?
    private var pManager:personModelManager = personModelManager.shared
    
    private  lazy var content:String = pManager.mode?.estimate?.content ?? ""
    
    weak var delegate:modifyItemDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView.init()
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.isScrollEnabled = false
        self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .plain, target: self, action: #selector(save))
        
        self.tableView.register(textViewCell.self, forCellReuseIdentifier: textViewCell.identity())
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "修改个人评价"
        
        self.navigationController?.insertCustomerView()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationItem.title = ""
        self.navigationController?.removeCustomerView()
        
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
        cacheCell = cell
        cell.placeHolderLabel.text = placeHolder
        cell.textView.delegate = self
        cell.textView.text = content
        cacheCell?.placeHolderLabel.isHidden = content.isEmpty ? false : true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return textViewCell.cellHeight()
    }
    
    


}


extension evaluateSelfVC{
    
    @objc func save(){
        self.view.endEditing(true)
        pManager.mode?.estimate?.content = content
        self.delegate?.modifiedItem(indexPath: IndexPath.init(row: 0, section: self.section))
        self.navigationController?.popViewController(animated: true)
        
    }
}
extension evaluateSelfVC: UITextViewDelegate{
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        cacheCell?.placeHolderLabel.isHidden =  textView.text.isEmpty ? false : true
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        cacheCell?.placeHolderLabel.isHidden =  textView.text.isEmpty ? false : true
        
        content = textView.text
        
        self.tableView.reloadData()
    
        
    }
    
}

