//
//  feedBackVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/18.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MobileCoreServices
import Photos



fileprivate let textPlaceHolder:String = "请填写内容，最多500字。"
//let feedBackEditNotify:String = "feedBackEditNotify"



fileprivate class postReq{
    
    var name:String = ""
    var describe:String = ""
    var data:[Data] = []
    init() {}
    
    
    internal func validate() -> Bool{
        if  name.isEmpty || describe.isEmpty {
            return false
        }
        return true
    }
    
}

class UserFeedBackVC: BaseTableViewController {

    enum catalogs:String {
        case problem = "problem"
        case idea = "idea"
        case contact = "contact"
        
        var describe:String{
            get{
                switch self {
                case .problem:
                    return "问题类型"
                case .idea:
                    return "反馈意见"
                // 不需要 这个数据
                case .contact:
                    return "联系方式"
                }
            }
        }
    }
    
    
    private lazy var dispose:DisposeBag = DisposeBag.init()
    
    private lazy var vm:PersonViewModel = PersonViewModel.shared
    
    
    // 上传的数据
    private lazy var  postBody:postReq = postReq.init()
    
    
    private var sectionTitle:[catalogs] = [.problem, .idea]
    
    //private var cell:TextAndPhontoCell?
    private var isEdit:Bool = false
    // app 启动获取
    private var problems:[String] = ["新功能建议","注册登录", "修改账号", "绑定账号", "招聘信息","宣讲会","搜索","简历修改","简历投递","订阅管理","笔试面试", "应用闪退","论坛","其他"]
    
    
    private lazy var showChooseImage:UIAlertController = { [unowned self] in
        let choose = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let fromCamera = UIAlertAction.init(title: "照相机", style: UIAlertAction.Style.default, handler: { [weak self] action in
            
            //self.selectPicture(type: UIImagePickerControllerSourceType)
            self?.picturType(type: .camera)
        })
        
        
        let fromPicture = UIAlertAction.init(title: "相册", style: UIAlertAction.Style.default, handler: { [weak self] action in
            self?.picturType(type: .pic)
        })
        
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        
        choose.addAction(fromCamera)
        choose.addAction(fromPicture)
        choose.addAction(cancel)
        return choose
     }()
    
    
    // photosview
    private lazy var photo:photosView = {
        let p = photosView(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: 89))
        p.setImage = {  [weak self] image in
            guard let `self` = self else {
                return
            }
            
            self.present(self.showChooseImage, animated: true, completion: nil)
            self.currentImage = image
            
        }
        return p
    }()
    
    private var image:UIImage?{
        didSet{
            currentImage?.image = image
            currentImage?.isHidden = false
            
        }
    }
    private var currentImage:UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        
     }
 
    
 
    override func setViews(){
        
        
        tableView.backgroundColor = UIColor.viewBackColor()
        tableView.tableFooterView = photo
        tableView.keyboardDismissMode = .onDrag
        tableView.register(FeedBackTypeCell.self, forCellReuseIdentifier: FeedBackTypeCell.identity())
        tableView.register(TextAndPhontoCell.self, forCellReuseIdentifier: TextAndPhontoCell.identity())
        self.title = "反馈意见"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发送", style: .plain, target: self, action: #selector(sendComment))
        
        //NotificationCenter.default.addObserver(self, selector: #selector(editing), name: NSNotification.Name.init(feedBackEditNotify), object: nil)
        
        NotificationCenter.default.rx.notification(NotificationName.feedBackNotiy, object: nil).subscribe(onNext: { [weak self] (notify) in
            self?.editing(notify)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        
    }
    
   
    
    
    
    override func currentViewControllerShouldPop()->Bool{
        
        if self.isEdit{
            let alertController = UIAlertController(title: nil, message: "编辑尚未结束，确定返回吗？", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "继续编辑", style: .default) { (_) in
                
            }
            alertController.addAction(alertAction)
            let cancelAction = UIAlertAction(title: "放弃修改", style: .cancel) { [weak self]  (_) in
                self?.navigationController?.popvc(animated: true)
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
            return false
            
        }
        return true
    }
    
    deinit {
        print("deinit userFeedBAckVC \(self)")
    }
    
    
    
    
    
    
    
}


extension UserFeedBackVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = UITableViewCell.init()
            cell.textLabel?.text = sectionTitle[indexPath.section].describe
            return cell
        }
        
        switch sectionTitle[indexPath.section] {
        case .problem:
            if let cell =  tableView.dequeueReusableCell(withIdentifier: FeedBackTypeCell.identity(), for: indexPath) as? FeedBackTypeCell{
                cell.mode = problems
                cell.selectItem = { [weak self] theme in
                   // print(theme)
                    self?.postBody.name = theme
                }
                return cell
            }
           
        case .idea:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TextAndPhontoCell.identity(), for: indexPath) as? TextAndPhontoCell{
                cell.placeholdStr = textPlaceHolder
                cell.delegate = self
                //self.cell = cell
                return cell 
            }
        default:
            break
            
        }
        
        return UITableViewCell()
    }
    
    // cell height
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 25
        }
        switch sectionTitle[indexPath.section] {
        case .problem:
           
            return tableView.cellHeight(for: indexPath, model: problems, keyPath: "mode", cellClass: FeedBackTypeCell.self, contentViewWidth: GlobalConfig.ScreenW)
        case .idea:
            return TextAndPhontoCell.cellHeight()
            
        default:
            break
        }
        return 0
    }
    
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  section == 0 ? 10 : 0
    }
}

extension UserFeedBackVC{
    @objc private func sendComment(){
        //print(photo.imageData)
        
        self.postBody.data = photo.imageData
        self.view.endEditing(true)
        if self.postBody.validate() == false {
            return
        }
        

        
        self.vm.uplodaUserFeedBack(name: self.postBody.name, describe: self.postBody.describe, data: self.postBody.data).subscribe(onNext: { [weak self] (res) in
            guard let code = res.code, HttpCodeRange.filterSuccessResponse(target: code) else {
                return
            }
            UIView.animate(withDuration: 3, animations: {
                self?.view.showToast(title: "发送成功", customImage: nil, mode: .text)
            }, completion: { _ in
                self?.navigationController?.popvc(animated: true)
            })
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.dispose)
        //print(self.postBody)
       
        // 发送成功后， 退出当前界面(发送频率限制？)
       
        
    }
    
}


extension UserFeedBackVC: TextAndPhontoCellDelegate{
    func getTextContent(text: String) {
        //print(text)
        self.postBody.describe = text
    }
}


extension UserFeedBackVC{
    @objc private func editing(_ sender: Notification){
        if let info = sender.userInfo as? [String:Bool], let edit = info["edit"]{
            self.isEdit = edit
        }
    }
}


// 照片
extension UserFeedBackVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    
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
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        var outputImage:UIImage?
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            outputImage = image
        }else if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            outputImage = image
        }
        guard outputImage != nil else {
            return
        }
        // 上传压缩image
        if let imageData = outputImage?.jpegData(compressionQuality: 0), let image = UIImage.init(data: imageData){
            //outputImage = UIImage.init(data: UIImageJPEGRepresentation(outputImage, 0))
            self.image = image
        }
        
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}




