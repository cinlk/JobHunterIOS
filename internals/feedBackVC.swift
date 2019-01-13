//
//  feedBackVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/18.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit



fileprivate let textPlaceHolder:String = "请填写内容，最多500字。"
let feedBackEditNotify:String = "feedBackEditNotify"


class feedBackVC: BaseTableViewController {

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
    
    // 上传的数据
    private lazy var  postBody:[String:Any] = [:]
    
    
    private var sectionTitle:[catalogs] = [.problem, .idea]
    
    //private var cell:TextAndPhontoCell?
    private var isEdit:Bool = false
    // app 启动获取
    private var problems:[String] = ["新功能建议","注册登录", "修改账号", "绑定账号", "招聘信息","宣讲会","搜索","简历修改","简历投递","订阅管理","笔试面试", "应用闪退","论坛","其他"]
    
    
    private lazy var showChooseImage:UIAlertController = { [unowned self] in
        let choose = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let fromCamera = UIAlertAction.init(title: "照相机", style: UIAlertAction.Style.default, handler: { action in
            
            //self.selectPicture(type: UIImagePickerControllerSourceType)
            self.selectPicture(type: UIImagePickerController.SourceType.camera)
        })
        
        
        let fromPicture = UIAlertAction.init(title: "相册", style: UIAlertAction.Style.default, handler: { action in
            self.selectPicture(type: UIImagePickerController.SourceType.photoLibrary)
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
        p.setImage = show
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
        tableView.register(feedBackTypeCell.self, forCellReuseIdentifier: feedBackTypeCell.identity())
        tableView.register(TextAndPhontoCell.self, forCellReuseIdentifier: TextAndPhontoCell.identity())
        self.title = "反馈意见"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发送", style: .plain, target: self, action: #selector(sendComment))
        
        NotificationCenter.default.addObserver(self, selector: #selector(editing), name: NSNotification.Name.init(feedBackEditNotify), object: nil)
        
    }
    
    
    
    
    
    override func currentViewControllerShouldPop()->Bool{
        
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
        return true
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    
    
}


extension feedBackVC {
    
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
            if let cell =  tableView.dequeueReusableCell(withIdentifier: feedBackTypeCell.identity(), for: indexPath) as? feedBackTypeCell{
                cell.mode = problems
                cell.selectItem = { theme in
                   // print(theme)
                    self.postBody["kind"]=theme
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
           
            return tableView.cellHeight(for: indexPath, model: problems, keyPath: "mode", cellClass: feedBackTypeCell.self, contentViewWidth: GlobalConfig.ScreenW)
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

extension feedBackVC{
    @objc private func sendComment(){
        //print(photo.imageData)
        
        
        self.view.endEditing(true)
        self.postBody["images"] = photo.imageData
        //print(self.postBody)
        // 发送成功后， 退出当前界面(发送频率限制？)
        self.navigationController?.popvc(animated: true)
        
    }
    
}


extension feedBackVC: TextAndPhontoCellDelegate{
    func getTextContent(text: String) {
        //print(text)
        self.postBody["content"] = text
    }
}


extension feedBackVC{
    @objc private func editing(_ sender: Notification){
        if let info = sender.userInfo as? [String:Bool], let edit = info["edit"]{
            self.isEdit = edit
        }
    }
}


// 照片
extension feedBackVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
  
    private func show(_ btn:inout UIImageView){
        self.present(showChooseImage, animated: true, completion: nil)
        self.currentImage = btn
    }
    
    
    func selectPicture(type: UIImagePickerController.SourceType){
        let select = UIImagePickerController()
        select.delegate = self
        select.allowsEditing = true
        select.sourceType = type
        self.present(select, animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var outputImage:UIImage?
        if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue
] as? UIImage{
            outputImage = image
        }else if let image = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage{
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




