//
//  ignoreCompanyVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/23.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class ignoreCompanyVC: UIViewController {

    
    private var pdata = privateViewMode.shared
    
    private lazy var textField:UITextField = {
        let tf = UITextField.init(frame: CGRect.zero)
        tf.delegate = self
        tf.textAlignment = .left
        tf.placeholder = "输入公司名称"
        tf.borderStyle = .roundedRect
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    private lazy var label:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textAlignment = .center
        label.text = "屏蔽企业"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    
    private lazy var addBtn:UIButton = {
        let btn = UIButton.init(frame: CGRect.zero)
        btn.setTitle("添加", for: .normal)
        btn.backgroundColor = UIColor.green
        //btn.isUserInteractionEnabled = false
        //btn.alpha = 0.5
        btn.addTarget(self, action: #selector(save), for: .touchUpInside)
        return btn
    }()
    
    // quit
    private lazy var quitBtn:UIButton = { [unowned self] in
        let btn = UIButton.init()
        btn.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        btn.addTarget(self, action: #selector(quit), for: .touchUpInside)
        return btn
        
    }()
    
    private var text:String = ""
    // 回调函数
    var  refresh:(()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        // Do any additional setup after loading the view.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        _ = label.sd_layout().topSpaceToView(self.view,80)?.leftSpaceToView(self.view,20)?.rightSpaceToView(self.view,20)?.heightIs(30)
        
        _ = textField.sd_layout().centerXEqualToView(label)?.leftSpaceToView(self.view,10)?.rightSpaceToView(self.view,10)?.heightIs(40)?.topSpaceToView(label,20)
        _ = quitBtn.sd_layout().rightSpaceToView(self.view,20)?.topSpaceToView(self.view,40)?.widthIs(40)?.heightIs(40)
        _ = addBtn.sd_layout().topSpaceToView(textField,60)?.leftEqualToView(textField)?.rightEqualToView(textField)?.heightIs(30)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


extension ignoreCompanyVC{
    
    private func initView(){
        let views:[UIView] = [textField, label, addBtn ,quitBtn]
        self.view.sd_addSubviews(views)
        self.view.backgroundColor = UIColor.init(r: 236, g: 236, b: 244)
        
    }
}


extension ignoreCompanyVC: UITextFieldDelegate {
    
    // 更加内容判断 btn 可用？？ TODO
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
      
    }
    
    
}


extension ignoreCompanyVC{
    
    @objc func quit(sender:UIButton){
        self.textField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func save(sender:UIButton){
        self.textField.resignFirstResponder()
        if let s = textField.text{
            pdata.addCompany(name: s)
        }
        self.dismiss(animated: true, completion: {
            self.refresh?()
        })
    }
}


