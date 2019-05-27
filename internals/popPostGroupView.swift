//
//  popPostGroupView.swift
//  internals
//
//  Created by ke.liang on 2019/5/27.
//  Copyright © 2019 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate let spaceWidth:CGFloat = 25
fileprivate let topText = "收藏成功,添加标签来分类"

class popPostGroupView: UIView {

    
    private var postId:String = ""
    // 之前已经选择的分组
    private var selectedGroup:[String] = []
    
    // 已经创建的分组
    private var groups:[String]  = SingletoneClass.shared.postGroups
    
    private lazy var  vm:ForumViewModel = ForumViewModel.init()
    
    
    private lazy var dispose:DisposeBag = DisposeBag.init()
    
    internal var postGroups:((_:[String])->Void)?
    
    private lazy var backGroudBtn:UIButton = {
        let v = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH))
        v.backgroundColor = UIColor.lightGray
        v.alpha = 0.5
        
        return v
    }()
    
    private lazy var topTitle:UIView  = {
        let v = UIView.init(frame:  CGRect.init(x: 0, y: 0, width: self.frame.width, height: 35))
        
        let l = UILabel.init(frame: CGRect.zero)
        l.text = topText
        l.setSingleLineAutoResizeWithMaxWidth(self.frame.width)
        l.textAlignment = .center
        v.addSubview(l)
        _ = l.sd_layout()?.centerXEqualToView(v)?.centerYEqualToView(v)?.autoHeightRatio(0)
        return v
        
    }()
    
    private lazy var table:UITableView = { [unowned self] in
        let tb = UITableView.init(frame: CGRect.init(x: 0, y: 35, width: self.frame.width, height: self.frame.height - 35 - GlobalConfig.toolBarH))
        tb.delegate = self
        tb.dataSource = self
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tb.tableFooterView = UIView.init()
        //tb.tableHeaderView = topTitle
        tb.allowsMultipleSelectionDuringEditing = true
        //tb.isEditing = true
        return tb

    }()
    
    private lazy var toolBar: UIView = {  [unowned self] in
        let t = UIView.init(frame: CGRect.init(x: 0, y: self.frame.height - GlobalConfig.toolBarH , width: self.frame.width, height: GlobalConfig.toolBarH))
        
        let cancel  = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: t.frame.width/2, height: t.frame.height))
        let confirm = UIButton.init(frame: CGRect.init(x: t.frame.width/2, y: 0 , width: t.frame.width/2, height: t.frame.height))
        cancel.setTitle("取消", for: .normal)
        cancel.setTitleColor(UIColor.lightGray, for: .normal)
        cancel.addTarget(self, action: #selector(quit), for: .touchUpInside)
        cancel.titleLabel?.textAlignment = .center
        confirm.setTitle("确定", for: .normal)
        confirm.setTitleColor(UIColor.orange, for: .normal)
        confirm.titleLabel?.textAlignment = .center
        confirm.addTarget(self, action: #selector(commit), for: .touchUpInside)

        t.addSubview(cancel)
        t.addSubview(confirm)
        return t
    }()
    
    private lazy var newName:newGroupName = { [unowned self] in
        let v = newGroupName.init(frame: CGRect.init(x: (GlobalConfig.ScreenW - 200)/2, y: (GlobalConfig.ScreenH - 150 - 300)/2, width: 200, height: 150))
        v.addName = { [weak self] name in
            guard let `self` = self else {
                return
            }
            self.backGroudBtn.isUserInteractionEnabled = true
            self.isHidden = false
            if !name.isEmpty, !self.groups.contains(name){
                
                self.groups.append(name)
                self.selectedGroup.append(name)
                self.table.reloadData()
            }
        }
        v.isHidden = true
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    
    }
    
    convenience init(frame:CGRect, postId: String){
        self.init(frame:frame)
        self.postId = postId
        
        setView()
        setViewModel()
    }
  
    
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}





extension popPostGroupView{
    private func setView(){
        self.backgroundColor = UIColor.white
        
        self.addSubview(self.topTitle)
        self.addSubview(self.table)
        self.addSubview(self.toolBar)
       
    }
    
    private func setViewModel(){
        self.backGroudBtn.rx.tap.asDriver().drive(onNext: { [weak self] in
            self?.dissmiss()
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        // 获取当前帖子 已有的分组
        self.vm.postGroup(postId: self.postId).subscribe(onNext: { [weak self] (res) in
            if let names = res.body?.group{
                self?.selectedGroup = names
                self?.table.reloadData()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
    }
}





extension popPostGroupView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
            cell.textLabel?.text =  "新增分组"
            //cell.rig
            cell.imageView?.image = #imageLiteral(resourceName: "plus")
            return cell
            // 新增分组
        }
        // 显示已有的分组
        let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
        if selectedGroup.contains(self.groups[indexPath.row - 1]){
              cell.imageView?.image = #imageLiteral(resourceName: "unchecked")
        }else{
              cell.imageView?.image = #imageLiteral(resourceName: "round")
        }
      
        cell.textLabel?.text =  groups[indexPath.row - 1]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            
            // 显示新建分组view
            self.isHidden = true
            self.backGroudBtn.isUserInteractionEnabled = false
            self.newName.show()
            //self.newName.textField.becomeFirstResponder()
            return
        }
        let cell = tableView.cellForRow(at: indexPath)
        
        if let text = cell?.textLabel?.text{
            if selectedGroup.contains(text){
               
                    selectedGroup.remove(at: selectedGroup.firstIndex(of: text)!)
            }else{
                selectedGroup.append(text)
            }
        }
        tableView.reloadData()
     }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if indexPath.row != 0 {
//            let cell = table.cellForRow(at: indexPath)
//            cell?.imageView?.image = #imageLiteral(resourceName: "round")
//        }
//    }
    
}
extension popPostGroupView{
    open func show(){
        
        UIApplication.shared.keyWindow?.addSubview(self.backGroudBtn)
        UIApplication.shared.keyWindow?.addSubview(self)

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            //self.isHidden = false
        }, completion: nil)
        
    }
    
    open func dissmiss(){
        
        self.backGroudBtn.removeFromSuperview()
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.removeFromSuperview()
            //self.isHidden = true
        }, completion: nil)
        
    }
    
    
    
    @objc internal func quit(){
        
        self.dissmiss()
    }
    
    @objc internal func commit(){
        
    
        // 得到帖子的分组
        
        self.dissmiss()
        self.postGroups?(self.selectedGroup)
    }
    
    
    
    
}





