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


fileprivate let VCtitle:String = "修改个人信息"
fileprivate let pickViewH:CGFloat = 200




class modify_personInfoVC: UITableViewController {

    // 记录item类型
    private var personAttr:[ResumeInfoType] = []
    // 记录pick 选择item的位置
    private var pickPosition:[ResumeInfoType:[Int:Int]] = [:]
    
    private let pManager:personModelManager = personModelManager.shared
    
    // 临时个人信息实例 需要拷贝？？
    private var tmpInfo:personBasicInfo?
    
    var section = 0{
        didSet{
             personAttr = pManager.mode!.basicinfo!.getBaseNames()
             tmpInfo = pManager.mode!.basicinfo
            
             self.tableView.reloadData()
        }
    }
    // 构建picker选择的需要数据
    private let selected:SelectItemUtil = SelectItemUtil.shared
    
    // 修改数据 代理
    weak var delegate:modifyItemDelegate?
    
    private var currentType:ResumeInfoType = ResumeInfoType.tx
    
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
    

    private lazy var pickView:itemPickerView = { [unowned self] in
        let pick = itemPickerView.init(frame: CGRect.init(x: 0, y: ScreenH, width: ScreenW, height: pickViewH))
        pick.backgroundColor = UIColor.white
        UIApplication.shared.windows.last?.addSubview(pick)
        pick.pickerDelegate = self
        return pick
        
    }()
    
    
    private lazy var  choosePicture:UIAlertController = { [unowned self] in
        
        let choosePicture =  UIAlertController.init(title: "请选择", message: nil, preferredStyle: .actionSheet)
        
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
        
        return choosePicture
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
        
    }


    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = VCtitle
        
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
        if let value =  tmpInfo?.getItemByType(type: personAttr[indexPath.row]){
            cell.mode = (type: personAttr[indexPath.row], value:value)
            cell.delegate = self
            return cell
        }
        
        return UITableViewCell()
        
    
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return modify_personInfoCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return  personAttr.count

    }
    
    
    // TODO 数据和Controllerview 应该解耦？？？ 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // MARK: 名字和treenode和plist和 struct是一致的

        currentType =  personAttr[indexPath.row]
        switch currentType {
        case .tx:
            self.present(choosePicture, animated: true, completion: nil)
        case .gender, .city, .degree, .birethday:
            pickView.mode = (currentType.rawValue, selected.getItems(name: currentType.rawValue)!)
            pickView.setPosition(position: pickPosition[currentType])
            showPickView()
            
        default:
            break
        }
    }
}


extension modify_personInfoVC: changeDataDelegate{
    
    func changeOtherInfo(viewType: resumeViewType, type: ResumeInfoType, value: String) {
        
    }
    
    
    func changeBasicInfo(type: ResumeInfoType, value: String) {
        tmpInfo?.changeValue(type: type, value: value)
    }
    

 
}


extension modify_personInfoVC{
    
    // 影藏pickview
    @objc private func hiddenBackGround(){
        
        self.navigationController?.view.willRemoveSubview(backgroundView)
        backgroundView.removeFromSuperview()
       
        UIView.animate(withDuration: 0.3, animations: {
            self.pickView.origin = self.pickViewOriginXY
        })
    
    }
    
    // 显示pickerview
    private func showPickView(){
        // 先取消编辑 影藏键盘
        self.view.endEditing(true)
        self.navigationController?.view.addSubview(backgroundView)
        UIView.animate(withDuration: 0.3, animations: {
            self.pickView.frame = CGRect.init(x: 0, y: ScreenH - pickViewH, width: ScreenW, height: pickViewH)
        })
    }
    
    
   
}

// pickerviewdelegate 协议
extension modify_personInfoVC:itemPickerDelegate{
    
    func quitPickerView(_ picker: UIPickerView) {
        self.hiddenBackGround()
    }
    
    func changeItemValue(_ picker: UIPickerView, value: String, position:[Int:Int]) {
        // 记录新的picker位置
        if let row = personAttr.index(of: currentType){
            pickPosition[currentType] = position
            
            //pManager.personBaseInfo?.changeByKey(type: currentType, value: value)
            tmpInfo?.changeValue(type: currentType, value: value)
            self.tableView.reloadRows(at: [IndexPath.init(item: row, section: 0)], with: .none)
        }
        
       self.hiddenBackGround()
    }
    
    // 保存修改
    @objc func save(){
        
        //MARK 修改远端服务器数据, 验证信息
//        if let v = tmpInfo{
//            pManager.personBaseInfo = v
//        }
        // 判断数据正确
        
        
        SVProgressHUD.show(UIImage.init(named: "checkmark")!, status: "修改成功")
        // 显示背景view 并禁止页面点击事件
        self.navigationController?.view.addSubview(backgroundView)
        self.navigationController?.view.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = false
        SVProgressHUD.setBackgroundColor(UIColor.lightGray)
        SVProgressHUD.dismiss(withDelay: 2) {  [unowned self] in
            self.navigationController?.popViewController(animated: true)
            // 主tableview刷新
            self.delegate?.modifiedItem(indexPath: IndexPath.init(row: 0, section: self.section))
            
            self.view.isUserInteractionEnabled = true
            self.navigationController?.view.isUserInteractionEnabled = true
            self.navigationController?.view.willRemoveSubview(self.backgroundView)
            self.backgroundView.removeFromSuperview()
        }
        
    }
    
}


// 照片
extension modify_personInfoVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
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
            // test
            pManager.mode?.basicinfo?.tx = "sina"
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
            self.tableView.endUpdates()
        }
    }
}




















