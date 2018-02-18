//
//  modify_personInfoTBC.swift
//  internals
//
//  Created by ke.liang on 2018/2/6.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
import SVProgressHUD


protocol personResumeDelegate: class {
    
    func refreshResumeInfo(_ section:Int)
}

class modify_personInfoTBC: UITableViewController {

    
    
    private var personAttr:[personBaseInfo] = []
    private var pickPosition:[personBaseInfo:[Int:Int]] = [:]
    private var pManager:personModelManager = personModelManager.shared

    
    var section = 0{
        didSet{
             personAttr = pManager.personBaseInfo!.getBaseNames()
             self.tableView.reloadData()
        }
    }

 
    
    private var selected:SelectItemUtil = SelectItemUtil.shared
    
    weak var delegate:personResumeDelegate?
    
    private var currentType:personBaseInfo = personBaseInfo.tx
    //tmp
    
    
    private lazy var backgroundView:UIView = { [unowned self] in
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH))
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
    
    // 记录pickerView 最初的位置
    private lazy var pickViewOriginXY:CGPoint = CGPoint.init(x: 0, y: 0)
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView.init()
        self.tableView.separatorStyle = .singleLine
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保 存", style: .plain, target: self, action: #selector(save))
        
        
        
        self.tableView.register(modify_personInfoCell.self, forCellReuseIdentifier: modify_personInfoCell.identity())
        self.pickViewOriginXY = pickView.origin
        
        // progressHUB 状态监听(全局的)
//        NotificationCenter.default.addObserver(self, selector: #selector(hubdiss(handleNotification:)), name: NSNotification.Name.SVProgressHUDDidDisappear, object: nil)
//
        
    }

//    deinit {
//        NotificationCenter.default.removeObserver(self)
//
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "修改个人信息"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: modify_personInfoCell.identity(), for: indexPath) as!
                    modify_personInfoCell
        cell.mode = (type: personAttr[indexPath.row], value:pManager.personBaseInfo!.getValueByType(type: personAttr[indexPath.row]))
        cell.delegate = self
        
        return cell
    
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return  personAttr.count

    }
    
    
    // TODO 数据和Controllerview 应该解耦？？？ 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        currentType =  personAttr[indexPath.row]
        ////名字和treenode和plist和 struct是一致的
        switch currentType {
        case .tx:
            let choosePicture = UIAlertController.init(title: "请选择", message: nil, preferredStyle: .actionSheet)
            
            let camera = UIAlertAction.init(title: "拍照", style: .default, handler: { (action) in
                print(action)
            })
            choosePicture.addAction(camera)
            
            let pictures = UIAlertAction.init(title: "从图库选择", style: .default, handler: { (action) in
                self.selectPic()
            })
            
            choosePicture.addAction(pictures)
            
            let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            choosePicture.addAction(cancel)
            self.present(choosePicture, animated: true, completion: nil)
            
        case .gender:
            pickView.mode = (personBaseInfo.gender.rawValue,selected.getItems(name: personBaseInfo.gender.rawValue)!)
            pickView.setPosition(position: pickPosition[currentType])
            //pickView.mode = (["性别"], selected.getItems(name: "性别")!)
            showPickView()
            
        case .city:
            pickView.mode = (personBaseInfo.city.rawValue,selected.getItems(name: personBaseInfo.city.rawValue)!)
            pickView.setPosition(position: pickPosition[currentType])
            showPickView()
        case .degree:
            pickView.mode = (personBaseInfo.degree.rawValue, selected.getItems(name: personBaseInfo.degree.rawValue)!)
            pickView.setPosition(position: pickPosition[currentType])
            showPickView()
        case .birethday:
            pickView.mode = (personBaseInfo.birethday.rawValue, selected.getItems(name: personBaseInfo.birethday.rawValue)!)
            pickView.setPosition(position: pickPosition[currentType])
            showPickView()
        default:
            break
        }
    }
}


extension modify_personInfoTBC: changeDataDelegate{
    
    func changeEducationInfo(viewType: resumeViewType, type: personBaseInfo, row: Int, value: String) {
        
    }
    
    
    func changeBaseInfo(type:personBaseInfo, value:String){
        pManager.personBaseInfo?.changeByKey(type: type, value: value)
    }
}


extension modify_personInfoTBC{
    
    @objc private func hiddenBackGround(){
        
        self.navigationController?.view.willRemoveSubview(backgroundView)
        backgroundView.removeFromSuperview()
       
        UIView.animate(withDuration: 0.3, animations: {
            self.pickView.origin = self.pickViewOriginXY
            
        }) { (bool) in
            
        }
    
    }
    
    private func showPickView(){
        // 取消编辑，影藏键盘
        self.view.endEditing(true)
        self.navigationController?.view.addSubview(backgroundView)
        UIView.animate(withDuration: 0.3, animations: {
            self.pickView.frame = CGRect.init(x: 0, y: ScreenH - 200, width: ScreenW, height: 200)
        }, completion: { (bool) in
            
        })
    }
    
    
   
}

// pickerviewdelegate
extension modify_personInfoTBC:itemPickerDelegate{
    
    func quitPickerView(_ picker: UIPickerView) {
        self.hiddenBackGround()
    }
    
    func changeItemValue(_ picker: UIPickerView, value: String, position:[Int:Int]) {
        // 记录新的picker位置
        if let row = personAttr.index(of: currentType){
            pickPosition[currentType] = position
            pManager.personBaseInfo?.changeByKey(type: currentType, value: value)
            self.tableView.reloadRows(at: [IndexPath.init(item: row, section: 0)], with: .none)
            self.hiddenBackGround()
        }
       
    }
    
    @objc func save(){
        
        // 返回 并显示提示
        
        SVProgressHUD.show(UIImage.init(named: "checkmark")!, status: "修改成功")
        self.navigationController?.view.addSubview(backgroundView)
        backgroundView.isUserInteractionEnabled = false
        SVProgressHUD.setBackgroundColor(UIColor.lightGray)
        SVProgressHUD.dismiss(withDelay: 2) {  [unowned self] in
            self.navigationController?.popViewController(animated: true)
            self.delegate?.refreshResumeInfo(self.section)
            self.backgroundView.isUserInteractionEnabled = true
            self.navigationController?.view.willRemoveSubview(self.backgroundView)
            self.backgroundView.removeFromSuperview()
        }
        
    }
    
    // 这里会执行2次?? SVProgressHUD  bug?
//    @objc func hubdiss(handleNotification:Notification){
//        print(handleNotification.userInfo)
//    }
}


// 照片
extension modify_personInfoTBC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    
    private func getPhotoLibraryAuthorization() -> Bool {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            print("已经授权")
            return true
        case .notDetermined:
            print("不确定是否授权")
            // 请求授权
            PHPhotoLibrary.requestAuthorization({ (status) in })
        case .denied:
            print("拒绝授权")
        case .restricted:
            print("限制授权")
            break
        }
        
        return false
    }
    
    
    private func selectPic(){
        // 相册
        guard  self.getPhotoLibraryAuthorization() else {
            print(" 不能xxx访问你的照片")
            return
        }
        
        guard  UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("设备不支持访问照片")
            return
        }
        
        let picker = UIImagePickerController()
            
        picker.delegate = self
        picker.mediaTypes = [kUTTypeImage as String]
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
            
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image:UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            picker.dismiss(animated: true, completion: nil)
            //  图片数据
            let _ =  UIImageJPEGRepresentation(image, 0.6)
            // MARK 上传图片，生成存储url地址
            // 更新 data 的image 地址，刷新table
            //UIImageView.init(image: UIImage.init(data: data))
            pManager.personBaseInfo?.setTX(tx: "chicken")
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
            self.tableView.endUpdates()
        }
    }
}




















