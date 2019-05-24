//
//  modify_personInfoTBC.swift
//  internals
//
//  Created by ke.liang on 2018/2/6.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import MobileCoreServices
import RxSwift
import RxCocoa
import Photos
import MBProgressHUD


fileprivate let VCtitle:String = "修改个人信息"
//let modifyPersonNotifyName:String = "modifyBaseInfo"

class modifyPersonInfoVC: BaseActionResumeVC {

    
    
    private lazy var dispose:DisposeBag = DisposeBag.init()
    private lazy var vm:PersonViewModel = PersonViewModel.shared
    
    
    private var mode:personalBaseInfoTextResume?
    private var indexPath:IndexPath?
    private var resumeId:String = ""
    
 
  
    
    // 修改数据 代理
    weak var delegate:modifyItemDelegate?
    
    
    private lazy var barItem:UIBarButtonItem = UIBarButtonItem.init(title: "保 存", style: .plain, target: nil, action: nil)
    
    
    private lazy var  choosePicture:UIAlertController = { [unowned self] in
        
        let choosePicture =  UIAlertController.init(title: "请选择", message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction.init(title: "拍照", style: .default, handler: { [weak self] (action) in
            self?.picturType(type: .camera)
        })
        choosePicture.addAction(camera)
        
        let pictures = UIAlertAction.init(title: "从图库选择", style: .default, handler: { [weak self] (action) in
            self?.picturType(type: .pic)
        })
        
        choosePicture.addAction(pictures)
        
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        choosePicture.addAction(cancel)
        
        return choosePicture
    }()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setViewModel()
        
        
    }

    deinit {
       print("deinit modifyPersonInofVC \(self)")
    }

    // 编辑状态
    override func currentViewControllerShouldPop() -> Bool {
       
        if self.isEdit{
            let alertController = UIAlertController(title: nil, message: "编辑尚未结束，确定返回吗？", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "继续编辑", style: .default) { (_) in
                
            }
            alertController.addAction(alertAction)
            let cancelAction = UIAlertAction(title: "放弃修改", style: .cancel) { [weak self] (_) in
                self?.navigationController?.popvc(animated: true)
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
            
        }
        
        // 未保存
        if self.isChange{
            
            let alertController = UIAlertController(title: nil, message: "修改尚未保存，确定返回吗？", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "保存并返回", style: .default) {  [weak self]  (_) in
                self?.save()
            }
            alertController.addAction(alertAction)
            let cancelAction = UIAlertAction(title: "放弃保存", style: .cancel) { [weak self] (_) in
                self?.navigationController?.popvc(animated: true)
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
        }
        
        return true
        
        
    }
    
    
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  keys.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = ModifyPersonInfoCell.init(style: .default, reuseIdentifier: "cell")
        
        cell.onlyPickerResumeType = onlyPickerResumeType
        cell.mode = (type: keys[indexPath.row], title: diction[keys[indexPath.row]]!)
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return ModifyPersonInfoCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // 这里图片没有 处理，会用默认图片
            self.present(choosePicture, animated: true, completion: nil)
        }
    }
    

    
}




extension modifyPersonInfoVC{
    
    internal func setData(resumeId:String, indexPath:IndexPath, mode: inout personalBaseInfoTextResume){
        self.resumeId = resumeId
        self.indexPath = indexPath
        self.mode = mode
    
        diction = mode.getTypeValue() ?? [:]
        keys = mode.getItemList()
        onlyPickerResumeType = mode.getPickerResumeType()
        self.tableView.reloadData()
        
    }
    
    private func setView(){
        
        self.title = VCtitle
        self.tableView.tableFooterView = UIView.init()
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.bounces = false
        self.navigationItem.rightBarButtonItem = barItem
        self.tableView.register(ModifyPersonInfoCell.self, forCellReuseIdentifier: ModifyPersonInfoCell.identity())
    }
    
    private func setViewModel(){
        barItem.rx.tap.asDriver().drive(onNext: { [weak self] in
          self?.save()
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        NotificationCenter.default.rx.notification(NotificationName.modifyResume, object: nil).subscribe(onNext: { [weak self] (notify) in
            self?.editStatus(notify)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
        
        let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.vm.loading.map({
            !$0
        }).drive(hub.rx.isHidden).disposed(by: self.dispose)
        
        self.vm.loading.map({
            $0
        }).drive(onNext: { [weak self] b in
            self?.navigationItem.hidesBackButton = b
            }, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
    }
    
    private func save(){
        
        
        guard self.checkValue() else  {
            return
        }
        // 上传到服务器
        res["resumeId"] = resumeId
        res["id"] = mode?.id!
        
        
        self.vm.textResumeContent(req: TextResumeBaseInfoReq.init(dict: res)).subscribe(onNext: { [weak self] (res) in
            guard let `self` = self else {
                return
            }
            if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                
                self.delegate?.modifiedItem(indexPath: self.indexPath!, type: .personInfo, mode:    personalBaseInfoTextResume.init(JSON: self.res)!)
                
                self.navigationController?.popvc(animated: true)
            }else{
                self.view.showToast(title: "保存失败", customImage: nil, mode: .text)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
//        if let data = personalBaseInfoTextResume(JSON: res){
//            //resumeBaseinfo = data
//            self.delegate?.modifiedItem(indexPath: mode!.indexPath)
//
//        }
//        self.navigationController?.popvc(animated: true)
        
    }
}



extension modifyPersonInfoVC: changeDataDelegate{
    
    func changeBasicInfo(type: ResumeInfoType, value: String) {
        if diction[type] == value{
            return
        }
        diction[type] = value
        isChange = true
        self.tableView.reloadRows(at: [IndexPath.init(row: keys.firstIndex(of: type)!, section: 0)], with: .automatic)
    }
    

 
}





// 照片
extension modifyPersonInfoVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    private func picturType(type: ChatMoreType){
        guard type == .pic || type == .camera  else {
            return
        }
        
        if Utils.PhotoLibraryAuthorization() == false{
            let warnMsg = type == .pic ? "没有相册的访问权限，请在应用设置中开启权限" : "没有相机的访问权限，请在应用设置中开启权限"
            self.tableView.presentAlert(type: UIAlertController.Style.alert, title: "温馨提示", message: warnMsg, items: [], target: self) { _  in }
            return
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            
            //设置代理
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = type == .pic ? .photoLibrary : .camera
            picker.mediaTypes = type == .pic ? [kUTTypeImage as String] : [kUTTypeImage as String,kUTTypeVideo as String]
            
            if type == .camera{
                if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.rear) {
                    picker.cameraDevice = UIImagePickerController.CameraDevice.rear
                }else if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.front){
                    picker.cameraDevice = UIImagePickerController.CameraDevice.front
                }
                
                //设置闪光灯(On:开、Off:关、Auto:自动)
                picker.cameraFlashMode = UIImagePickerController.CameraFlashMode.auto
                
            }
            
            
            self.present(picker, animated: true, completion: nil)
            
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel")
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // 选择image
        var imageData:Data?
        var imageName = ""
        
        var selectedImage:UIImage?
        
        if let originImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImage = originImage
        }else if let editImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImage = editImage
        }
        
        if let image = selectedImage{
            if picker.sourceType == .camera{
                // 照相的照片 默认是jpeg 格式
                // 生成时间戳 和 扩展名的 图片名称
                
                let DateFormat = DateFormatter.init()
                //
                DateFormat.dateFormat = "yyyy-MM-dd HH.mm.ss"
                imageName = DateFormat.string(from: Date()) + ".jpeg"
                
                
                imageData =  image.jpegData(compressionQuality: 0)
                
                
            }else if picker.sourceType == .photoLibrary{
                // 照片库
                // 获取名称
                let imagePathURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
                imageName = imagePathURL!.lastPathComponent
                // 文件扩展类型
                let fileType =  imageName.components(separatedBy: ".").last!
                if fileType.lowercased() == "jpeg"{
                    imageData = image.jpegData(compressionQuality: 0)
                }else{
                    imageData = image.pngData()
                }
                
            }
            
            
            
            
            
        }else{
            self.view.showToast(title: "未选择图片", customImage: nil, mode: .text)
        }
        
        picker.dismiss(animated: true, completion: { [weak self] in
            guard let `self` = self else{
                return
            }
            if imageData != nil && !imageName.isEmpty{
                
                // 上传到服务器
                self.vm.textResuemBaseInfoAvatar(resumeId: self.resumeId, data: imageData!, name: imageName).subscribe(onNext: { [weak self] (res) in
                    guard let `self` = self else {
                        return
                    }
                    if let url = res.body?.iconURL{
            
                        self.mode?.tx = url
                        self.diction[.tx] = url.absoluteString
                        self.tableView.reloadRows(at: [IndexPath.init(row: self.keys.firstIndex(of: .tx)!, section: 0)], with: .automatic)
                        // 通知父vc 刷新
                        self.delegate?.modifiedItem(indexPath: self.indexPath!, type: .personInfo, mode: self.mode!)
                    }else{
                        self.view.showToast(title: "更新头像失败", customImage: nil, mode: .text)
                    }
                    
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
                // 更新ui
            }
            
        })
    }
    
}




















