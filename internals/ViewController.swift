//
//  ViewController.swift
//  internals
//
//  Created by ke.liang on 2017/8/26.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var phoneNumber: UITextField!
    
    
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        phoneNumber.delegate = self
        password.delegate = self
        
        phoneNumber.keyboardAppearance = .dark
        phoneNumber.returnKeyType = .done
        phoneNumber.keyboardType = .numberPad
        
        password.keyboardAppearance = .dark
        password.returnKeyType = .done
        password.isSecureTextEntry = true
        
        
        // textfield 下边框
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: phoneNumber.frame.height-1, width: phoneNumber.frame.width-30, height: 1)
        bottomLine.backgroundColor  = UIColor.black.cgColor
        phoneNumber.borderStyle = UITextBorderStyle.none
        phoneNumber.layer.addSublayer(bottomLine)
        
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0, y: password.frame.height-1, width: password.frame.width-30, height: 1)
        bottomLine2.backgroundColor  = UIColor.black.cgColor
        password.borderStyle = UITextBorderStyle.none
        password.layer.addSublayer(bottomLine2)
        
        
        //NSNotification.addObserver(self, forKeyPath: <#T##String#>, options: <#T##NSKeyValueObservingOptions#>, context: <#T##UnsafeMutableRawPointer?#>)
        self.touchDefine()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(_ sender: Any) {
        print (" go to registry view")
        //let regiterView = self.storyboard.
        let registerView =  RegisterViewController()
        self.navigationController?.pushViewController(registerView, animated: true)
    }

    
    @IBAction func login(_ sender: UIButton) {
        
        
        let user = ["name":"lk","role":"admin"]
        
        print("forward to main")
        self.performSegue(withIdentifier: "showMain", sender: user)
        
    
    }
    
    
    // didStart
    @IBAction func Inputphone(_ sender: UITextField) {
        print(" edit start")
    }
    
    
    
    @IBAction func forgetPassword(_ sender: Any) {
        
        print(" go to set password")
        let passwordView = ForgetPasswordController()
        
        self.navigationController?.pushViewController(passwordView, animated: true)
        
    }
    
    func touchDefine(){
        
        let tap = UITapGestureRecognizer(target:self, action:#selector(self.closeKeyboard))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)

    }
    
    @objc private func  closeKeyboard(){
        self.view.endEditing(true)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMain"{
            print("go forward to Main")
            
            let controller = segue.destination as? MainTabBarViewController
            
            controller?.info = sender as? Dictionary
           
        }
        
    }
    
    //textfield delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //        textField.becomeFirstResponder()
        let frame: CGRect = textField.frame
        
        let offset: CGFloat = frame.origin.y+32-(self.view.frame.size.height-216)
        let animationDuration : TimeInterval = 0.30
        
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        
        UIView.setAnimationDuration(animationDuration)
        
        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
        if(offset>0) {
            self.view.frame = CGRect(x:0.0, y: -offset, width:self.view.frame.size.width,
                                     height:self.view.frame.size.height)
            
        }
        
        UIView.commitAnimations()
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        self.view.frame = CGRect(x:0, y:0, width:self.view.frame.size.width,
                                 height:self.view.frame.size.height)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
}

