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
import MBProgressHUD


fileprivate let VCtitle:String = "修改个人信息"
let modifyPersonNotifyName:String = "modifyBaseInfo"

class modifyPersonInfoVC: BaseActionResumeVC {

    
    var mode:(indexPath:IndexPath, info:personalBasicalInfo)?{
        didSet{
            guard  let mode = mode, let kv =  mode.info.getTypeValue() else {
                return
            }
            
            diction = kv
            keys = mode.info.getItemList()
            onlyPickerResumeType = mode.info.getPickerResumeType()
            
            
            self.tableView.reloadData()
        }
    }
  
    
    // 修改数据 代理
    weak var delegate:modifyItemDelegate?
    
    
    
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
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = VCtitle
        
        self.tableView.tableFooterView = UIView.init()
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.bounces = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保 存", style: .plain, target: self, action: #selector(save))
        
        
        self.tableView.register(modifyPersonInfoCell.self, forCellReuseIdentifier: modifyPersonInfoCell.identity())
        
        NotificationCenter.default.addObserver(self, selector: #selector(editStatus), name: NSNotification.Name.init(modifyPersonNotifyName), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // 编辑状态
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
        
        return false
        
        
    }
    
    
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  keys.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = modifyPersonInfoCell()
        cell.onlyPickerResumeType = onlyPickerResumeType
        cell.mode = (type: keys[indexPath.row], title: diction[keys[indexPath.row]]!)
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return modifyPersonInfoCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // 这里图片没有 处理，会用默认图片
            self.present(choosePicture, animated: true, completion: nil)
        }
    }
    

    
}






extension modifyPersonInfoVC: changeDataDelegate{
    
    func changeBasicInfo(type: ResumeInfoType, value: String) {
        diction[type] = value
        isChange = true
        
        self.tableView.reloadRows(at: [IndexPath.init(row: keys.index(of: type)!, section: 0)], with: .automatic)
    }
    

 
}


extension modifyPersonInfoVC{
    
    
    // 保存修改
    @objc func save(){
        
        if super.checkValue() == false{
            return
        }
        
        if let data = personalBasicalInfo(JSON: res){
            resumeBaseinfo = data
            self.delegate?.modifiedItem(indexPath: mode!.indexPath)
            
        }
        self.navigationController?.popvc(animated: true)
    }
    
 
    
}


// 照片
extension modifyPersonInfoVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
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
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var resultImage:UIImage?
        
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage, let imagData = UIImageJPEGRepresentation(image, 0){
           
            //  图片数据
            
            // MARK 上传图片，生成存储url地址
            // 更新 data 的image 地址，刷新table
            //UIImageView.init(image: UIImage.init(data: data))
            // test
           
            resultImage =   UIImage.init(data: imagData)
            
            //pManager.mode?.basicinfo?.tx = "sina"
            
            
        }
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage,  let imagData = UIImageJPEGRepresentation(image, 0){
            
             resultImage =   UIImage.init(data: imagData)
             //pManager.mode?.basicinfo?.tx = "sina"
            
        }
        if resultImage != nil{
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
            self.tableView.endUpdates()
        }
       
        
        picker.dismiss(animated: true, completion: nil)
        
    }
}




















