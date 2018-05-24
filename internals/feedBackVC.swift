//
//  feedBackVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/18.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit



fileprivate let textPlaceHolder:String = "请填写内容，最多500字。"


class feedBackVC: UITableViewController {

 
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
                case .contact:
                    return "联系方式"
                }
            }
        }
    }
    
    private var contacts = ["邮箱","手机"]
    
    private var sectionTitle:[catalogs] = [.problem, .idea, .contact]
    
    private var cell:TextAndPhontoCell?
    
    
    private lazy var showChooseImage:UIAlertController = { [unowned self] in
        let choose = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let fromCamera = UIAlertAction.init(title: "照相机", style: UIAlertActionStyle.default, handler: { action in
            
            //self.selectPicture(type: UIImagePickerControllerSourceType)
            self.selectPicture(type: UIImagePickerControllerSourceType.camera)
        })
        
        
        let fromPicture = UIAlertAction.init(title: "相册", style: UIAlertActionStyle.default, handler: { action in
            self.selectPicture(type: UIImagePickerControllerSourceType.photoLibrary)
        })
        
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        
        choose.addAction(fromCamera)
        choose.addAction(fromPicture)
        choose.addAction(cancel)
        return choose
     }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "反馈意见"
        self.navigationController?.insertCustomerView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        self.navigationController?.removeCustomerView()
 
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       
    }
    

}


extension feedBackVC{
    
    override  func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  section == 2 ? 3 : 2
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
                cell.mode = ["新功能建议","注册登录", "修改账号", "绑定账号", "招聘信息","宣讲会","搜索","简历修改","简历投递","订阅管理","笔试面试", "应用闪退","论坛","其他"]
                cell.selectItem = { theme in
                    print(theme)
                }
                return cell
            }
           
        case .idea:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TextAndPhontoCell.identity(), for: indexPath) as? TextAndPhontoCell{
                cell.setImage = {
                    self.present(self.showChooseImage, animated: true, completion: nil)
                }
                self.cell = cell
                return cell 
            }
            
        case .contact:
            
            if let cell  = tableView.dequeueReusableCell(withIdentifier: innerTextFiledCell.identity(), for: indexPath) as? innerTextFiledCell{
                cell.mode = (placeholder:"选填", title: contacts[indexPath.row - 1], content:"")
                
                return cell 
            }
           
            
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
            let mode = ["新功能建议","注册登录", "修改账号", "绑定账号", "招聘信息","宣讲会","搜索","简历修改","简历投递","订阅管理","笔试面试", "应用闪退","论坛","其他"]
            
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: feedBackTypeCell.self, contentViewWidth: ScreenW)
        case .idea:
            return TextAndPhontoCell.cellHeight()
            
        default:
            break
        }
        return 45
    }
    
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}

extension feedBackVC{
    
    private func setViews(){
        self.tableView.backgroundColor = UIColor.viewBackColor()
        self.tableView.tableFooterView = UIView()
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.register(feedBackTypeCell.self, forCellReuseIdentifier: feedBackTypeCell.identity())
        self.tableView.register(TextAndPhontoCell.self, forCellReuseIdentifier: TextAndPhontoCell.identity())
        self.tableView.register(innerTextFiledCell.self, forCellReuseIdentifier: innerTextFiledCell.identity())
        self.tableView.bounces = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发送", style: .plain, target: self, action: #selector(sendComment))
    }
    
    @objc private func sendComment(){
        self.view.endEditing(true)
    }
}


// 照片
extension feedBackVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func selectPicture(type: UIImagePickerControllerSourceType){
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
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            outputImage = image
        }else if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            outputImage = image
        }
        guard outputImage != nil else {
            return
        }
        // 上传压缩image
        if let imageData = UIImageJPEGRepresentation(outputImage!, 0), let image = UIImage.init(data: imageData){
            //outputImage = UIImage.init(data: UIImageJPEGRepresentation(outputImage, 0))
            if cell?.imageOne  == nil {
                cell?.imageOne = image
                
            }else{
                cell?.imageTwo = image
            }
        }
        
        
        picker.dismiss(animated: true, completion: nil)
        
    }
}




