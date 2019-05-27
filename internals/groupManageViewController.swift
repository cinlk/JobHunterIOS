//
//  groupManageViewController.swift
//  internals
//
//  Created by ke.liang on 2019/5/27.
//  Copyright © 2019 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ObjectMapper

fileprivate let hint:String = "左滑编辑和删除分组"
fileprivate let navTitle:String = "分组标签管理"

class groupManageViewController: BaseViewController {

    
    
    
    private var datas:[UserRelateGroup] = []
    
    private lazy var vm:PersonViewModel = PersonViewModel.shared
    private lazy var dispose:DisposeBag = DisposeBag.init()
    
    private var currentEditIndex:IndexPath?
    
    private lazy var headRefresh: UIRefreshControl = {
        let re = UIRefreshControl.init()
        re.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return re
    }()
    
    private lazy var headerHint:UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: 40))
        let l = UILabel.init()
        l.setSingleLineAutoResizeWithMaxWidth(GlobalConfig.ScreenW)
        l.text = hint
        l.font = UIFont.systemFont(ofSize: 16)
        v.addSubview(l)
        v.backgroundColor = UIColor.viewBackColor()
        _ = l.sd_layout()?.leftSpaceToView(v, 15)?.topSpaceToView(v,10)?.autoHeightRatio(0)
        
        return v
    }()
    private lazy var table:UITableView = { [unowned self] in
        let t = UITableView.init()
        t.delegate = self
        t.dataSource = self
        t.tableFooterView = UIView.init()
        t.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        t.refreshControl = self.headRefresh
        return t
    }()
    
    
    
    private lazy var changeName:newGroupName = {
        let v = newGroupName.init(frame: CGRect.init(x: (GlobalConfig.ScreenW - 200)/2, y: (GlobalConfig.ScreenH - 150 - 300)/2, width: 200, height: 150))
        v.addName = { [weak self] name in
            guard let `self` = self, let index = self.currentEditIndex, !name.isEmpty else {
                return
            }
            
            if name != self.datas[index.row].name{
            
                self.vm.renameGroupPostName(name: name, id: self.datas[index.row].groupId ?? "").subscribe(onNext: { [weak self] (res) in
                    
                    guard let `self`  = self else {
                        return
                    }
                    
                    guard let code = res.code,  HttpCodeRange.filterSuccessResponse(target: code) else {
                        self.table.showToast(title: "失败", customImage: nil, mode: .text)
                        return
                    }
                    
                    self.table.showToast(title: "成功", customImage: nil, mode: .text)
                    self.datas[index.row].name = name
                    self.table.reloadRows(at: [index], with: UITableView.RowAnimation.automatic)
                    
                    
                    }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
                
            }
        }
        
        
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViews()
        self.loadData()
       
        // Do any additional setup after loading the view.
    }
    

    
    
    override func setViews() {
        self.view.backgroundColor = UIColor.viewBackColor()
        self.view.addSubview(self.table)
        self.table.tableHeaderView = self.headerHint
        self.hiddenViews.append(self.table)
        _ = table.sd_layout()?.leftEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)?.rightEqualToView(self.view)
        table.backgroundColor = UIColor.viewBackColor()
        
        self.title = navTitle
        super.setViews()
        
    }
    

    
    
    override func didFinishloadData() {
        super.didFinishloadData()
        self.headRefresh.endRefreshing()
        self.table.reloadData()
    }
    
//    override func reload() {
//        super.reload()
//        self.loadData()
//    }
    
    
    
    
    
    deinit {
        print("deinit  groupManageViewController\(self)")
    }

}


extension groupManageViewController{
    
    private func loadData(){
        
        // 获取用户 收藏帖子的 分组数据
        NetworkTool.request(.userPostGroups, successCallback: {  data in
            
            guard  let d = data as? [String:Any],let target =  d["body"] as? [[String:Any]] else {
                return
            }
            
            let res = Mapper<UserRelateGroup>().mapArray(JSONArray: target)
//            res.forEach({
//                if let n = $0.name{
//                    SingletoneClass.shared.postGroups.append(n)
//                }
//                
//            })
            
            self.datas =  res
            self.didFinishloadData()
            
            
        }) { (err) in
            
        }
    }
}

extension groupManageViewController{
    @objc private func refresh(){
        self.loadData()
    }
    
    private func showEdit(){
        
        
    }
    

}



extension groupManageViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = datas[indexPath.row].name
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction.init(style: .normal, title: "编辑") { [weak self]  (UITableViewRowAction, indexPath) in
            // 显示编辑界面
            self?.changeName.show(withBacgroud: true, editText: self?.datas[indexPath.row].name ?? "")
            self?.currentEditIndex = indexPath
        }
        
        edit.backgroundColor = UIColor.blue
        edit.accessibilityFrame  = CGRect.init(x: 0, y: 0, width: 30, height: 30)

        
        let delete = UITableViewRowAction.init(style: .destructive, title: "删除") { [unowned self] (action, index) in
           // 删除
            
            
            guard let name = self.datas[index.row].name else {
                return
            }
            self.vm.deleteUserPostGroup(name: name).subscribe(onNext: { [weak self] (res) in
                
                guard let code = res.code, HttpCodeRange.filterSuccessResponse(target: code) else {
                    tableView.showToast(title: "删除失败", customImage: nil, mode: .text)
                    return
                }
                self?.datas.remove(at: index.row)
                tableView.reloadData()
                
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
            
        }
        delete.backgroundColor = UIColor.red
        delete.accessibilityFrame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        
        // 删除不能放前面 出现滑动删除效果
        return [edit,delete]
        
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let deleteAction = UIContextualAction.init(style: UIContextualAction.Style.destructive, title: "删除", handler: { [unowned self] (action, view, completion) in
            guard let name = self.datas[indexPath.row].name else {
                return
            }
            self.vm.deleteUserPostGroup(name: name).subscribe(onNext: { [weak self] (res) in
                
                guard let code = res.code, HttpCodeRange.filterSuccessResponse(target: code) else {
                    completion(false)
                    tableView.showToast(title: "删除失败", customImage: nil, mode: .text)

                    return
                }
                self?.datas.remove(at: indexPath.row)
                tableView.reloadData()
                completion(true)
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
            
        })
        
        deleteAction.backgroundColor = UIColor.red
        
        
        let editAction = UIContextualAction.init(style: UIContextualAction.Style.normal, title: "编辑", handler: { [unowned self] (action, view, completion) in
            
            self.changeName.show(withBacgroud: true, editText: self.datas[indexPath.row].name ?? "")
            self.currentEditIndex = indexPath
            completion(true)
        })
        
        editAction.backgroundColor = UIColor.blue
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        // 禁止滑动过多 删除cell
        config.performsFirstActionWithFullSwipe = false
        return config
        
    }
    
    
}







