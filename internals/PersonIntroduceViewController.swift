//
//  PersonIntroduceViewController.swift
//  internals
//
//  Created by ke.liang on 2019/5/18.
//  Copyright © 2019 lk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MobileCoreServices
import Photos

fileprivate let navTitle:String = "个人信息"

class PersonIntroduceViewController: UITableViewController {

    
    private  var mode:PersonInTroduceInfo!{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    
    private lazy var vm: PersonViewModel =  PersonViewModel.shared
    private lazy var dispose:DisposeBag = DisposeBag.init()
    
    
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
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    convenience  init(style: UITableView.Style, mode:PersonInTroduceInfo) {
        self.init(style: style)
        self.mode = mode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setViewModel()
        //self.tableView.reloadData()
        
    }
    
    
    deinit {
        print("deinit personeIntroduceViewController \(self)")
    }
    
    // table
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mode.types.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ModifyPersonInfoCell.identity(), for: indexPath) as! ModifyPersonInfoCell
        cell.onlyPickerResumeType  = self.mode.getPickerResumeType()
        cell.mode = (self.mode.types[indexPath.row], self.mode[indexPath.row])
        cell.delegate = self
        return cell
        
    }
    
    override func cellHeight(for indexPath: IndexPath!, cellContentViewWidth width: CGFloat) -> CGFloat {
        return  ModifyPersonInfoCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row  == 0 {
            self.present(choosePicture, animated: true, completion: nil)
        }
    }
    
    
    
}


extension PersonIntroduceViewController: changeDataDelegate{
    
    func changeBasicInfo(type: ResumeInfoType, value: String) {
        //diction[type] = value
        //isChange = true
        
        //self.tableView.reloadRows(at: [IndexPath.init(row: keys.firstIndex(of: type)!, section: 0)], with: .automatic)
        
        switch type {
        case .name:
            if value.isEmpty{
                self.view.showToast(title: "名称不能为空", customImage: nil, mode: .text)
                return
            }
            self.mode.name = value
        case .gender:
            self.mode.gender = value
        case .colleage:
            self.mode.colleage = value
        default:
            break
        }
        
        
        // 上传到服务器
        self.vm.updateBrief(req: PersonBriefReq.init(name: self.mode.name, gender: self.mode.gender, colleage: self.mode.colleage)).subscribe(onNext: { [unowned self] (res) in
            if let code = res.code, HttpCodeRange.filterSuccessResponse(target: code){
                
                self.tableView.reloadRows(at: [IndexPath.init(row: self.mode.types.firstIndex(of: type)!, section: 0)], with: .automatic)
                
                GlobalUserInfo.shared.userData["name"] = self.mode.name
                GlobalUserInfo.shared.userData["gender"] = self.mode.gender
                GlobalUserInfo.shared.userData["colleage"] = self.mode.colleage
                NotificationCenter.default.post(name: NotificationName.updateBriefInfo, object: nil)
                
            }else{
                self.view.showToast(title: "修改失败", customImage: nil, mode: .text)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        // 更新ui
    }
    

    
}


extension PersonIntroduceViewController{
    
    
    private func setView(){
        self.title = navTitle
        self.tableView.backgroundColor = UIColor.backGroundColor()
        self.tableView.tableFooterView = UIView.init()
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.register(ModifyPersonInfoCell.self, forCellReuseIdentifier: ModifyPersonInfoCell.identity())
        
    }
    
    
    private func setViewModel(){
        //NotificationCenter
        // s上传 等待 界面不能操作
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
  

}





extension PersonIntroduceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    
   
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
    
    
    
    
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
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
                self.vm.updateAvatar(data: imageData!, name: imageName).subscribe(onNext: { (res) in
                    if let url = res.body?.iconURL{
                        self.mode[0] = url.absoluteString
                        GlobalUserInfo.shared.userData["user_icon"] = url.absoluteString
                        NotificationCenter.default.post(name: NotificationName.updateBriefInfo, object: nil)
                        self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
                    }
                }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
                // 更新ui
            }
            
        })
    }
    
}
