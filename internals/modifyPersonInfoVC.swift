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


class modifyPersonInfoVC: UITableViewController {

    
    private var diction:[ResumeInfoType:String] = [:]
    private var keys:[ResumeInfoType] = []
    private var onlyPickerResumeType:[ResumeInfoType] = []
    
    
    var mode:(indexPath:IndexPath, info:personalBasicalInfo)?{
        didSet{
            guard  let mode = mode else {
                return
            }
            
            diction = mode.info.getTypeValue()
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
        self.tableView.tableFooterView = UIView.init()
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.bounces = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "保 存", style: .plain, target: self, action: #selector(save))
        
        self.tableView.register(modifyPersonInfoCell.self, forCellReuseIdentifier: modifyPersonInfoCell.identity())
        
    }


    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = VCtitle
        self.navigationController?.insertCustomerView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        self.navigationController?.removeCustomerView()
        
        
    }
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  keys.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: modifyPersonInfoCell.identity(), for: indexPath) as?
            modifyPersonInfoCell{
            cell.onlyPickerResumeType = onlyPickerResumeType
            cell.mode = (type: keys[indexPath.row], title: diction[keys[indexPath.row]]!)
            cell.delegate = self
            return cell
        }
        
        return UITableViewCell()
        
    
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
        
        self.tableView.reloadRows(at: [IndexPath.init(row: keys.index(of: type)!, section: 0)], with: .automatic)
    }
    

 
}


extension modifyPersonInfoVC{
    
    
    // 保存修改
    @objc func save(){
        
        self.view.endEditing(true)
        
        var res:[String:Any] = [:]
        diction.forEach{
            res[$0.key.rawValue] = $0.value
        }
        
        if let data = personalBasicalInfo(JSON: res){
            personModelManager.shared.mode?.basicinfo = data
            self.delegate?.modifiedItem(indexPath: mode!.indexPath)
            
        }
        self.navigationController?.popViewController(animated: true)
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




















