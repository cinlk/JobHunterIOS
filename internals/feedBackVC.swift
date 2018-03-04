//
//  feedBackVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/18.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import SVProgressHUD

fileprivate let typeTitle:String = "请选择意见类型"
fileprivate let content:String = "反馈内容"
fileprivate let contact:String = "你的联系方式"
fileprivate let textPlaceHolder:String = "请填写内容，最多500字。"


fileprivate let name:String = "反馈"

class feedBackVC: UIViewController {

    
    private lazy var topTitle:UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: NavH, width: ScreenW, height: 30))
        v.backgroundColor = UIColor.lightGray
        let label = UILabel.init(frame: CGRect.zero)
        label.text = typeTitle
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.sizeToFit()
        v.addSubview(label)
        _ = label.sd_layout().leftSpaceToView(v,10)?.topSpaceToView(v,5)?.bottomSpaceToView(v,5)?.rightSpaceToView(v,10)
        return v
    }()
    
    private lazy var wrapperView:UIView = { [unowned self] in
        let v = UIView.init(frame: CGRect.zero)
        v.backgroundColor = UIColor.white
        let tap = UITapGestureRecognizer.init()
        tap.addTarget(self, action: #selector(pick))
        tap.numberOfTapsRequired = 1
        v.addGestureRecognizer(tap)
        return v
    }()
    
    private lazy var typeLabel:UILabel = {
       let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.blue
        label.font = UIFont.systemFont(ofSize: 20)
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    
    //
    private lazy var contentTitle:UIView = {
        let v = UIView.init(frame: CGRect.zero)
        v.backgroundColor = UIColor.lightGray
        let label = UILabel.init(frame: CGRect.zero)
        label.text = content
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.sizeToFit()
        v.addSubview(label)
        _ = label.sd_layout().leftSpaceToView(v,10)?.topSpaceToView(v,5)?.bottomSpaceToView(v,5)?.rightSpaceToView(v,10)
        return v
    }()
    

    private lazy var textView:UITextView = { [unowned self] in
        let text = UITextView.init(frame: CGRect.zero)
        text.textColor = UIColor.black
        text.font = UIFont.systemFont(ofSize: 16)
        text.textAlignment = .left
        // 调整输入内容偏移
        text.textContainerInset = UIEdgeInsetsMake(10, 8, 0, 0)
        text.delegate = self
        return text
    }()
    
    // textview placeholder 值
    private lazy var textPlaceholder:UILabel = {
        let placeHolder = UILabel.init(frame: CGRect.zero)
        placeHolder.text = textPlaceHolder
        placeHolder.textAlignment = .left
        placeHolder.textColor = UIColor.lightGray
        placeHolder.font = UIFont.systemFont(ofSize: 16)
        return placeHolder
    }()
    // last
    
    
    private lazy var contactTitle:UIView = {
        let v = UIView.init(frame: CGRect.zero)
        v.backgroundColor = UIColor.lightGray
        let label = UILabel.init(frame: CGRect.zero)
        label.text = contact
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.sizeToFit()
        v.addSubview(label)
        _ = label.sd_layout().leftSpaceToView(v,10)?.topSpaceToView(v,5)?.bottomSpaceToView(v,5)?.rightSpaceToView(v,10)
        return v
    }()
    
    private lazy var wrapperContactField:UIView = {
        let v = UIView.init(frame: CGRect.zero)
        v.backgroundColor = UIColor.white
        return v
    }()
    private lazy var contactField:UITextField = { [unowned self] in
        let field = UITextField.init(frame: CGRect.zero)
        field.textAlignment = .left
        field.font = UIFont.systemFont(ofSize: 16)
        field.delegate = self
        // 左边留部分距离
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 30))
        field.leftView = v
        field.leftViewMode = .always
        field.placeholder = "手机或邮箱联系方式(选填)"
        return field
    }()
    
    
    private lazy var pickView:itemPickerView = {
        let pick = itemPickerView.init(frame: CGRect.init(x: 0, y: ScreenH, width: ScreenW, height: 200))
        pick.backgroundColor = UIColor.white
        UIApplication.shared.windows.last?.addSubview(pick)
        pick.pickerDelegate = self
        return pick
        
    }()
    
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
    
    // 键盘 toolbar
    private lazy var doneButton:UIToolbar = { [unowned self] in
        
        let toolBar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: ScreenW, height: 35))
        toolBar.backgroundColor = UIColor.gray
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barBtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(textStorage))
        toolBar.items = [spaceBtn, barBtn]
        toolBar.sizeToFit()
        return toolBar
        }()
    
    private lazy var pickViewOriginXY:CGPoint = CGPoint.init(x: 0, y: 0)
    private var selected:SelectItemUtil = SelectItemUtil.shared
    private var pickPosition:[String:[Int:Int]] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.viewBackColor()
        pickViewOriginXY = pickView.origin
        setNavigationBtn()
        keyboardEvent()
        
        
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "反馈意见"
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        buildView()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

}


extension feedBackVC{
    
    private func setNavigationBtn(){
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发送", style: .plain, target: self, action: #selector(postMsg))
    }
    
    @objc func postMsg(){
        
        self.view.endEditing(true)
        
        if typeLabel.text == nil{
            
        }else if textView.text.isEmpty{
            
        }else if (contactField.text?.isEmpty)!{
            
        }
        SVProgressHUD.show(#imageLiteral(resourceName: "checkmark"), status: "发送成功")
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        SVProgressHUD.dismiss(withDelay: 2) {
             self.navigationController?.navigationBar.isUserInteractionEnabled = true
        }
        //print("类型 \(typeLabel.text) 内容 \(textView.text)  联系方式 \(contactField.text)")
        
    }
    
    
    private func buildView(){
        self.view.addSubview(topTitle)
        self.view.addSubview(wrapperView)
        self.view.addSubview(contentTitle)
        wrapperView.addSubview(typeLabel)
        self.view.addSubview(textView)
        textView.addSubview(textPlaceholder)
        self.view.addSubview(contactTitle)
        self.view.addSubview(wrapperContactField)
        wrapperContactField.addSubview(contactField)
        // 添加完成 btn
        textView.inputAccessoryView = doneButton
        contactField.inputAccessoryView = doneButton
        
        
        _ = wrapperView.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(topTitle,0)?.heightIs(60)
        _ = typeLabel.sd_layout().centerXEqualToView(wrapperView)?.centerYEqualToView(wrapperView)?.widthIs(200)?.heightIs(30)
        _ = contentTitle.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(wrapperView,0)?.heightIs(30)
        
        _ = textView.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(contentTitle,0)?.heightIs(160)
        _ = textPlaceholder.sd_layout().leftSpaceToView(textView,10)?.topSpaceToView(textView,5)?.rightSpaceToView(textView,10)?.heightIs(25)
        
        _ = contactTitle.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(textView,0)?.heightIs(30)
        
        _ = wrapperContactField.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topSpaceToView(contactTitle,0)?.heightIs(30)
        _ = contactField.sd_layout().leftEqualToView(wrapperContactField)?.rightEqualToView(wrapperContactField)?.topEqualToView(wrapperContactField)?.bottomEqualToView(wrapperContactField)
        
        
    }
    
}

extension feedBackVC{
    
    @objc func pick(){
        pickView.mode =  (name,selected.getItems(name: name)!)
        pickView.setPosition(position: pickPosition[name])
        self.showPickView()
    }
    
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
    
    @objc func textStorage(){
        self.view.endEditing(true)
    }
    
    private func keyboardEvent(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardHidden(sender: NSNotification){
        
        // 下降view的y坐标
        UIView.animate(withDuration: 0.5) {
            self.view.origin.y = 0
        }
    }
    
    
    @objc func keyboardShow(sender: NSNotification){
        // 上升view 的y坐标
        if  let kframe = sender.userInfo![UIKeyboardFrameEndUserInfoKey] as? CGRect{
            
            let offsetY = kframe.height - (ScreenH - (self.wrapperContactField.origin.y + self.wrapperContactField.frame.height)) + 20
            UIView.animate(withDuration: 0.5) {
                if offsetY > 0 {
                    self.view.origin.y = -offsetY
                }
                
            }
        }
        
    }
    
}

extension feedBackVC: itemPickerDelegate{
    
    func quitPickerView(_ picker: UIPickerView) {
        self.hiddenBackGround()
    }
    
    func changeItemValue(_ picker: UIPickerView, value: String, position:[Int:Int]) {
        // 记录新的picker位置
        pickPosition[name] = position
        typeLabel.text = value
        hiddenBackGround()
    }
        
}

extension feedBackVC: UITextViewDelegate{
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
       
        // 显示默认的placeholder
        if textView.text.isEmpty{
            textPlaceholder.isHidden = false
        }else{
            textPlaceholder.isHidden = true
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
       
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count > 10{
            print("字数太多")
            return
        }
        
    }
    
}


extension feedBackVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}

