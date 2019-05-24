//
//  ResumePageViewController.swift
//  internals
//
//  Created by ke.liang on 2018/7/4.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


fileprivate let maxCount = 5
fileprivate let navTitle = "我的简历"
//fileprivate let delegateNotify = Notification.Name.init("ResumePageViewController")

class ResumePageViewController: BaseTableViewController {

  
    private lazy var dispose:DisposeBag = DisposeBag.init()
    private lazy var vm:PersonViewModel = PersonViewModel.shared
    
    
    private lazy var myResumes:[ReumseListModel] = []
    

    private  var isEdit:Bool = false
    private var tableDelegate:delegateHandler!
    
    
    private lazy var menu:SearchTypeMenuView = {
        let m = SearchTypeMenuView.init(frame: CGRect.init(x: GlobalConfig.ScreenW - 100 , y: GlobalConfig.NavH, width: 120, height: SearchTypeMenuView.cellHeight() * 2 + 10),arrowLeftMargin: 65)
        //m.delegate = self
        m.table.layer.cornerRadius = 0
        m.datas = [.online, .attachment]
        return m
        
    }()
    
    private lazy var barBtn:UIBarButtonItem = {
       
        return UIBarButtonItem.init(image: #imageLiteral(resourceName: "plus").changesize(size: CGSize.init(width: 20, height: 20)), style: .plain, target: nil, action: nil)
    }()
    
    // 背景btn
//    private lazy var backgroundBtn:UIButton = {
//        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH))
//        btn.addTarget(self, action: #selector(hiddenPopMenu), for: .touchUpInside)
//        btn.backgroundColor = UIColor.lightGray
//        btn.alpha = 0.5
//        return btn
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setViewModel()
        loadData()
        
     }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.insertCustomerView(UIColor.orange)

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    
    deinit {
        print("deinit resumePageController \(self)")
    }
    
    
    override func setViews() {
    
        self.title = navTitle
        
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.viewBackColor()
        tableView.register(ResumePageCell.self, forCellReuseIdentifier: ResumePageCell.identity())
        //self.navigationController?.delegate = self
        //_ = menu.sd_layout().topSpaceToView(self.view,GlobalConfig.NavH)?.rightSpaceToView(self.view,10)?.widthIs(100)?.heightIs(SearchTypeMenuView.cellHeight() * 2 )
        
         //NotificationCenter.default.addObserver(self, selector: #selector(notifyHandler), name: delegateNotify, object: nil)
        navigationItem.rightBarButtonItem = barBtn
        
        super.setViews()
        
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "plus").changesize(size: CGSize.init(width: 20, height: 20)), style: .plain, target: self, action: #selector(addMore))
        
        tableDelegate = delegateHandler.init(resumes: myResumes, table: self.tableView)
        tableView.dataSource = tableDelegate
        tableView.delegate = tableDelegate
        // 添加项目的代理
        menu.delegate = tableDelegate
        
        self.tableView.reloadData()
    }
    
    override func reload() {
        super.reload()
        self.loadData()
    }
    
    
    // 如果需要拦截系统返回按钮就重写该方法返回 false
    override func currentViewControllerShouldPop() -> Bool {
        if self.isEdit{
            let alertController = UIAlertController(title: nil, message: "简历名称尚未保存，确定返回吗？", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "继续编辑", style: .default) { (_) in
                
            }
            alertController.addAction(alertAction)
            let cancelAction = UIAlertAction(title: "放弃修改", style: .cancel) { [weak self] (_) in
                //self.view.endEditing(true)
                self?.navigationController?.popvc(animated: true)
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
        
        }
        
        return true
        
    }
    
}












extension ResumePageViewController{
    
    private func setViewModel(){
        NotificationCenter.default.rx.notification(NotificationName.resume, object: nil).subscribe(onNext: { [weak self] (notify) in
            
            if let info = notify.userInfo as? [String:Bool]{
                if let edit = info["edit"]{
                    self?.isEdit = edit
                }else if let refresh = info["refresh"], refresh{
                    self?.loadData(refresh: true)
                }

            }else if let info = notify.userInfo as? [String:Any]{
                if let action = info["action"] as? String, let vc = info["target"] as? UIViewController{
                    if action == "push"{
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }else if action == "present"{
                        self?.present(vc, animated: true, completion: nil)
                    }
                }
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        //
        barBtn.rx.tap.asDriver().drive(onNext: { [weak self] in
            
            if self?.isEdit ?? true{
                return
            }
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                //self.navigationController?.view.addSubview(self.backgroundBtn)
            }, completion: { [weak self] bool in
                self?.menu.show()
                
            })
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
    }
    private func loadData(refresh: Bool = false ){
        
        self.vm.resumeList().flatMapLatest({ modes in
            return Observable.just(modes)
        }).asDriver(onErrorJustReturn: []).drive(onNext: { [weak self] (modes) in
            self?.myResumes = modes
            if refresh{
                self?.tableDelegate.myResumes = modes
                self?.tableView.reloadData()
            }else{
                self?.didFinishloadData()
            }
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)

    }
}





// 自定义class

fileprivate class  operatorHandler:NSObject{
    
    
    // 默认投递只有一个
    internal  var defaultResumeRow:Int?
    // 当前行
    internal  var selectedrow:Int?
    
    internal  var myResumes:[ReumseListModel] = []
    
    internal lazy var vm:PersonViewModel = PersonViewModel.shared
    internal lazy var dispose:DisposeBag = DisposeBag.init()
    // 控制 编辑内容
    internal  var isEdit:Bool = false{
        didSet{
            NotificationCenter.default.post(name: NotificationName.resume, object: self, userInfo: ["edit":isEdit])

        }
    }
    
    internal var tableView:UITableView!
    
    
    // 在线简历显示的操作
    internal lazy var alertOnlineVC:UIAlertController = {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let defaults = UIAlertAction.init(title: "设置为默认", style: UIAlertAction.Style.default, handler: { [weak self] action in
            self?.setDefaultItem()
        })
        let rename = UIAlertAction.init(title: "重命名", style: UIAlertAction.Style.default, handler: { [weak self] action in
            self?.renameItem()
            
        })
        let copy = UIAlertAction.init(title: "复制", style: UIAlertAction.Style.default, handler: { [weak self]  action in
            self?.copyItem()
        })
        
        let delete = UIAlertAction.init(title: "删除", style: UIAlertAction.Style.destructive, handler: {[weak self] action in
            self?.deleteItem()
        })
        
        let cancel =  UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alert.addAction(defaults)
        alert.addAction(rename)
        alert.addAction(copy)
        alert.addAction(delete)
        alert.addAction(cancel)
        return alert
    }()
    
    // 附件简历显示的操作
    internal lazy var alertAttachVC:UIAlertController = {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        let defaults = UIAlertAction.init(title: "设置为默认", style: UIAlertAction.Style.default, handler: { [weak self]  action in
            self?.setDefaultItem()
        })
        let rename = UIAlertAction.init(title: "重命名", style: UIAlertAction.Style.default, handler: {[weak self]  action in
            self?.renameItem()
            
        })
        
        let delete = UIAlertAction.init(title: "删除", style: UIAlertAction.Style.destructive, handler: {[weak self] action in
            self?.deleteItem()
        })
        
        let cancel =  UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alert.addAction(defaults)
        alert.addAction(rename)
        alert.addAction(delete)
        alert.addAction(cancel)
        return alert
    }()
    
    
    
    init(resumes: [ReumseListModel], table:UITableView) {
        self.myResumes = resumes
        self.tableView = table
        super.init()
    }
    
    
    
}


// 实现菜单代理
extension operatorHandler: SearchMenuDelegate{
    func selectedItem(item: searchItem){
        
        //self.hiddenPopMenu()
        
        // 添加在线简历
        if item == .online{
            if self.myResumes.count >= maxCount{
                self.tableView.showToast(title: "最多添加\(maxCount)个在线简历", customImage: nil, mode: .text)
                //showOnlyTextHub(message: "最多添加\(maxCount)个在线简历", view: self.tableView)
                return
            }
            
            //  后台服务器创建 文本 简历
            self.vm.newTextResume().subscribe(onNext: { [weak self] (res) in
                guard let `self` =  self  else {
                    return
                }
                if let b = res.body{
                    self.myResumes.append(b)
                    self.tableView.insertRows(at: [IndexPath.init(row: self.myResumes.count - 1, section: 0)], with: .automatic)
                }else{
                    self.tableView.showToast(title: "创建失败", customImage: nil, mode: .text)
                }
                
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
            
            
//            if let resume = ReumseListModel(JSON: ["name":"我的简历","isDefault":false,"id":Utils.getUUID(),
//                                              "create_time":Date().timeIntervalSince1970,"kind":item.rawValue]){
//
//                self.myResumes.append(resume)
//                self.tableView.insertRows(at: [IndexPath.init(row: myResumes.count - 1, section: 0)], with: .automatic)
            
            
        }else{
            // 添加附件简历
            // 显示提示界面 TODO
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//            let fromPC = UIAlertAction.init(title: "从电脑上传", style: .default) { action in
//
//            }
            let fromPhone = UIAlertAction.init(title: "上传简历", style: .default) { action in
                
            }
            let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            //alert.addAction(fromPC)
            alert.addAction(fromPhone)
            alert.addAction(cancel)
            NotificationCenter.default.post(name: NotificationName.resume, object: self, userInfo: ["action":"present","target":alert])
            
        }
        
    }
    
    
}

extension operatorHandler{
    
    private func setDefaultItem(){
        // http 服务错误处理 TODO
        if let row = self.selectedrow, row != self.defaultResumeRow, let rid = self.myResumes[row].resumeId{
            
            self.vm.setPrimaryResume(resumeId: rid).subscribe(onNext: { [weak self] (res) in
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    
                    self?.myResumes[row].isPrimary = true
                    // 默认的index 改变
                    
                    if let df = self?.defaultResumeRow{
                        self?.myResumes[df].isPrimary = false
                    }
                    self?.defaultResumeRow = row
                    self?.tableView.reloadData()
                }else{
                    self?.tableView.showToast(title: "系统错误", customImage: nil, mode: .text)
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
          
        }
    }
    
    // 编辑简历 名字
    private func renameItem(){        
        
        if let row = self.selectedrow{
            
            let cell = tableView.cellForRow(at: IndexPath.init(row: row, section: 0)) as! ResumePageCell
            cell.startEdit = true
            self.isEdit = true
        }
    }
    
    
    // 只对在线简历拷贝
    private func copyItem(){
        
        if let row = self.selectedrow{
            
            if myResumes.count >= maxCount{
                self.tableView.showToast(title: "最多添加\(maxCount)个简历", customImage: nil, mode: .text)
                //showOnlyTextHub(message: "最多添加\(maxCount)个简历", view: self.tableView)
                return
            }
            // 拷贝字典
            let target =  myResumes[row]
            
            guard target.resumeKind == .text else {
                return
            }
            
            // 服务器数据复制一份 MARK ！！
            
            if let data = ReumseListModel(JSON: [
                "name": target.name! + "副本",
                "is_primary": false,
                "resume_id": Utils.getUUID(),
                "create_time": Date().timeIntervalSince1970,
                "type": target.resumeKind.rawValue]){
                
                myResumes.append(data)
                
                self.tableView.insertRows(at: [IndexPath.init(row: myResumes.count - 1, section: 0)], with: .automatic)
                
            }
            
        }
        
    }
    
    private func deleteItem(){
        
        // 提示告警
        let alert = UIAlertController(title: nil, message: "删除后无法恢复，确认删除?", preferredStyle: .alert)
        let confirm = UIAlertAction.init(title: "确定", style: .default) {  [weak self] action in
            guard let `self` = self else {
                return
            }
            if let row = self.selectedrow, let rid = self.myResumes[row].resumeId{
                
                self.vm.deleteResume(resumeId: rid , type: self.myResumes[row].resumeKind).subscribe(onNext: { [weak self] (res) in
                    if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                        
                        self?.myResumes.remove(at: row)
                        // 重置默认简历row
                        if row == self?.defaultResumeRow{
                            self?.defaultResumeRow = nil
                        }
                        
                        self?.tableView.deleteRows(at: [IndexPath.init(row: row, section: 0)], with: .automatic)
                        
                    }else{
                        self?.tableView.showToast(title: "删除失败", customImage: nil, mode: .text)
                    }
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
                
                
            }
            
        }
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancel)
        alert.addAction(confirm)
        NotificationCenter.default.post(name: NotificationName.resume, object: self, userInfo: ["action":"present","target":alert])
 
        
        
    }
}



fileprivate class delegateHandler:operatorHandler{
    
     override init(resumes: [ReumseListModel], table:UITableView) {
        super.init(resumes: resumes, table: table)
    }
    
    
}


extension delegateHandler: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // 结束编辑(失去焦点结束会调用)
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // 键盘输入结束会调用
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text,  text.isEmpty{
            return false
        }
        let text = textField.text?.trimmingCharacters(in: CharacterSet.init(charactersIn: " "))
        if (text?.isEmpty)!{
            return false
        }
        
        updateName(textField.text!)
        textField.isUserInteractionEnabled = false
        self.isEdit = false
        return true
    }
    
    private func updateName(_ text: String){
       
        // 更新简历名称
        if let row = self.selectedrow, let rid = self.myResumes[row].resumeId{
            self.vm.newResumeName(resumeId: rid, name: text).subscribe(onNext: { [weak self] (res) in
                if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                    self?.myResumes[row].name = text
                    self?.tableView.reloadRows(at: [IndexPath.init(row: row, section: 0)], with: .automatic)
                }
              
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        }
        
    }
}

extension delegateHandler:UITableViewDataSource, UITableViewDelegate{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myResumes.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ResumePageCell.identity(), for: indexPath) as! ResumePageCell
        cell.textTitle.delegate = self
        
        let mode = myResumes[indexPath.row]
        if mode.isPrimary == true{
            defaultResumeRow =  indexPath.row
        }
        
        
        cell.mode = mode
        cell.setting = { [weak self]  btn in
            guard  let `self` = self else {
                return
            }
            if !self.isEdit{
                
                let v = btn.superview
                //  index 表示其它cell有添加删除后，该cell 实际对应的位置
                if let cell = v?.superview as? ResumePageCell, let index = tableView.indexPath(for: cell){
                        self.selectedrow = index.row
                        print(index)
                }
                
                if mode.resumeKind == .text{
                    NotificationCenter.default.post(name: NotificationName.resume, object: self, userInfo: ["action":"present","target":self.alertOnlineVC])

                 }else {
                    NotificationCenter.default.post(name: NotificationName.resume, object: self, userInfo: ["action":"present","target":self.alertAttachVC])
 
                }
            }
        }
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isEdit{
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        let mode = myResumes[indexPath.row]
        if mode.resumeKind == .text{
            let vc = PersonTextResumeViewController()
            vc.resumeID = mode.resumeId
             NotificationCenter.default.post(name: NotificationName.resume, object: self, userInfo: ["action":"push","target":vc])
         }else{
            
            self.vm.attachResumeURL(resumeId: mode.resumeId!).subscribe(onNext: { [weak self] (res) in
                if let url = res.body?.url{
                      let vc = BaseWebViewController.init()
                      vc.mode = url
                      NotificationCenter.default.post(name: NotificationName.resume, object: self, userInfo: ["action":"push","target":vc])
                }else{
                    self?.tableView.showToast(title: "查看失败", customImage: nil, mode: .text)
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
            
            
            
          

         }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = myResumes[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: ResumePageCell.self, contentViewWidth: GlobalConfig.ScreenW)
    }
    
    
}



