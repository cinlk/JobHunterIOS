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

    private lazy var tbHeader:UIView = {
        let tb = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 40))
        tb.backgroundColor = UIColor.white
        return tb
    }()
    
    private lazy var backgroundView:UIView = { [unowned self] in
        // 不能用self.bound.frame, y 会上移64像素
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH))
        v.backgroundColor = UIColor.lightGray
        v.alpha = 0.5
        v.isUserInteractionEnabled = false
        return v
        
        }()
    
    
    private var  cacheCell:textViewCell?
    private var pManager:personModelManager = personModelManager.shared
    var section:Int = 0
    private var content:String = ""
    
    weak var delegate:modifyItemDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView.init()
        self.tableView.tableHeaderView = tbHeader
        self.tableView.backgroundColor = UIColor.white
        self.tableView.isScrollEnabled = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保存", style: .plain, target: self, action: #selector(save))
        
        self.tableView.register(textViewCell.self, forCellReuseIdentifier: textViewCell.identity())
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "修改个人评价"
        content = pManager.mode?.estimate ?? ""
        self.navigationController?.insertCustomerView()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationItem.title = ""
        self.navigationController?.removeCustomerView()
        
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: textViewCell.identity(), for: indexPath) as!
            textViewCell
        cacheCell = cell
        cell.placeHolderLabel.text = placeHolder
        cell.textView.delegate = self
        cell.textView.text = content
        cacheCell?.placeHolderLabel.isHidden = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return textViewCell.cellHeight()
    }
    
    


}


extension evaluateSelfVC{
    
    @objc func save(){
        self.view.endEditing(true)
       
        if content.isEmpty{
            self.navigationController?.navigationBar.isUserInteractionEnabled = false

            let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
            hub.mode = .customView
            hub.customView = UIImageView.init(image: #imageLiteral(resourceName: "error").changesize(size: CGSize.init(width: 25, height: 25)))
            hub.label.text = "错误原因"
            hub.margin = 10
            hub.label.textColor = UIColor.white
            hub.bezelView.backgroundColor = UIColor.backAlphaColor()
            hub.removeFromSuperViewOnHide = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                
                hub.hide(animated: true)
                self.navigationController?.navigationBar.isUserInteractionEnabled = true
            }
        }else{
            pManager.mode?.estimate = content
            self.delegate?.modifiedItem(indexPath: IndexPath.init(row: 0, section: self.section))
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}
extension evaluateSelfVC: UITextViewDelegate{
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        cacheCell?.placeHolderLabel.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty{
            cacheCell?.placeHolderLabel.isHidden = false
        }else{
             cacheCell?.placeHolderLabel.isHidden = true
        }
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text.isEmpty{
             cacheCell?.placeHolderLabel.isHidden = false
        }
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            cacheCell?.placeHolderLabel.isHidden = false
            return
        }
        
        content = textView.text
        
        self.tableView.reloadData()
    
        
    }
    
}

