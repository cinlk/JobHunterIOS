//
//  historyAndCatagoryView.swift
//  internals
//
//  Created by ke.liang on 2017/9/19.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import YNSearch



// 代理传值
protocol valueDelegate{
    func valuePass(string: String)
}


class YNSearchData: YNSearchModel {
    var title = "YNSearch"
    var starCount = 271
    var description = "Awesome fully customize search view like Pinterest written in Swift 3"
    var version = "0.3.1"
    var url = "https://github.com/younatics/YNSearch"
}

class YNExpandableCell: YNSearchModel {
    var title = "YNExpandableCell"
    var starCount = 191
    var description = "Awesome expandable, collapsible tableview cell for iOS written in Swift 3"
    var version = "1.1.0"
    var url = "https://github.com/younatics/YNExpandableCell"
}

class  Test1: YNSearchModel {
    var title = "测试公司"
    var startCount = 101
    var description = "搜索测试"
    var version = "1.1.0"
    var url = "http://gitcoin.org"
}


class  Test2: YNSearchModel {
    var title = "测试助理实现"
    var startCount = 101
    var description = "搜索测试"
    var version = "1.1.0"
    var url = "http://gitcoin.org"
}


class  Test3: YNSearchModel {
    var title = "测量助理试验"
    var startCount = 101
    var description = "搜索测试"
    var version = "1.1.0"
    var url = "http://gitcoin.org"
}







class historyAndCatagoryView: YNSearchViewController {

    
    var searchString:valueDelegate? = nil
    let ynSearch = YNSearch()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        

        // Do any additional setup after loading the view.
    }
    
    func initView(){
        
        let demoCategories = ["Menu", "Animation", "Transition", "TableView", "CollectionView", "Indicator", "Alert", "UIView", "UITextfield", "UITableView", "Swift", "iOS", "Android"]
        let demoSearchHistories = ["Menu", "Animation", "Transition", "TableView"]
        
        
        ynSearch.setCategories(value: demoCategories)
        ynSearch.setSearchHistories(value: demoSearchHistories)
        
        self.view.backgroundColor = UIColor.white
        
        self.ynSearchinit()
        self.ynSearchTextfieldView.ynSearchTextField.clearButtonMode = .whileEditing
        
        self.delegate = self
        
        
        
        self.initData(database: self.loadDataForSearch())
        
        self.setYNCategoryButtonType(type: .colorful)
        // Do any additional setup after loading the view.
        
        // 取消keyboard
        self.ynSearchTextfieldView.ynSearchTextField.enablesReturnKeyAutomatically = true
        let keyboard = UITapGestureRecognizer(target: self, action: #selector(closeKeyBoard))
        keyboard.cancelsTouchesInView = false
        self.view.addGestureRecognizer(keyboard)
    }
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.ynSearchView.ynSearchMainView.redrawSearchHistoryButtons()
        
        let name = self.ynSearch.getSearchName()
        
        self.ynSearchTextfieldView.cancelButton.alpha = 1
        self.ynSearchTextfieldView.cancelButton.isHidden = false
        self.ynSearchTextfieldView.ynSearchTextField.backgroundColor = UIColor.gray
        
        if self.ynSearchView.ynSearchMainView.isHidden == true && (name?.isEmpty)! {
            UIView.animate(withDuration: 0.3, animations: {
                self.ynSearchView.ynSearchMainView.alpha = 1
                self.ynSearchView.ynSearchListView.alpha = 0
            }) { (true) in
                self.ynSearchView.ynSearchMainView.isHidden = false
                self.ynSearchView.ynSearchListView.isHidden = true
                
            }
        }
        
        self.ynSearchTextfieldView.ynSearchTextField.text = name
        if name != nil  && !((name?.isEmpty)!){
            self.ynSearchTextfieldTextChanged(self.ynSearchTextfieldView.ynSearchTextField)
        }

        
        
        
    }
    
    
    
    override func ynSearchTextfieldcancelButtonClicked() {
        super.ynSearchTextfieldcancelButtonClicked()
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    // 自定义搜索内容匹配显示
    override func ynSearchTextfieldTextChanged(_ textField: UITextField) {
        guard var  text = textField.text else {return }
        
        guard !text.isEmpty else {
            UIView.animate(withDuration: 0.3, animations: {
                self.ynSearchView.ynSearchMainView.alpha = 1
                self.ynSearchTextfieldView.cancelButton.alpha = 1
                self.ynSearchView.ynSearchListView.alpha = 0
            }) { (true) in
                self.ynSearchView.ynSearchMainView.isHidden = false
                self.ynSearchView.ynSearchListView.isHidden = true
                self.ynSearchTextfieldView.cancelButton.isHidden = false
                
            }
            return
            
            
        }
        guard text.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.ynSearchView.ynSearchMainView.alpha = 1
                self.ynSearchTextfieldView.cancelButton.alpha = 1
                self.ynSearchView.ynSearchListView.alpha = 0
            }) { (true) in
                self.ynSearchView.ynSearchMainView.isHidden = false
                self.ynSearchView.ynSearchListView.isHidden = true
                self.ynSearchTextfieldView.cancelButton.isHidden = false
                
            }
            return
        }
        
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        UIView.animate(withDuration: 0.01, animations: {
            self.ynSearchView.ynSearchMainView.alpha = 0
            self.ynSearchTextfieldView.cancelButton.alpha = 1
            self.ynSearchView.ynSearchListView.alpha = 1
        }) { (true) in
            self.ynSearchView.ynSearchMainView.isHidden = true
            self.ynSearchView.ynSearchListView.isHidden = false
            self.ynSearchTextfieldView.cancelButton.isHidden = false
            
        }
        
        self.ynSearchView.ynSearchListView.ynSearchTextFieldText = text
        
        
    }
    
    // 替换父类实现的 view显示
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard var text = textField.text else { return true }
        if !text.isEmpty {
            
            text = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if text != "" {
                self.ynSerach.appendSearchHistories(value: text)
                self.ynSearchView.ynSearchMainView.redrawSearchHistoryButtons()
                self.forwardSearch(text: text)
                
            }
            else{
                //搜索不能为空，显示warning
                let alert = UIAlertController(title: "搜索词为空", message: nil, preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                //
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2){
                    self.presentedViewController?.dismiss(animated: false, completion: nil)
                    
                }
            }
            
            
            return true
            
        }
        self.ynSearchTextfieldView.ynSearchTextField.resignFirstResponder()
        return false
        
    }
    
    
    func forwardSearch(text:String){
        
        self.searchString?.valuePass(string: text)
        self.ynSearch.setShareSearchName(value: text)
        self.ynSearchTextfieldView.ynSearchTextField.endEditing(true)
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    
    
    
    
    private func loadDataForSearch()-> [YNSearchModel]{
        
        // 搜索数据库初始化
        //let database1 = YNDropDownMenu(key: "YNDropDownMenu")
        let database2 = YNSearchData(key: "YNSearchData")
        let database3 = YNExpandableCell(key: "YNExpandableCell")
        
        
        var demoDatabase = [ database2, database3]
        
        demoDatabase.append(Test1(key: "test1"))
        demoDatabase.append(Test2(key: "test2"))
        demoDatabase.append(Test3(key: "test3"))
        
        
        return demoDatabase
    }

    
    func closeKeyBoard(){
        self.ynSearchTextfieldView.ynSearchTextField.resignFirstResponder()
        
    }



}




extension historyAndCatagoryView: YNSearchDelegate{
    
    func ynCategoryButtonClicked(text: String) {
        
        self.forwardSearch(text: text)
        
    }
    func ynSearchHistoryButtonClicked(text: String) {
        self.forwardSearch(text: text)
    }
    
    func ynSearchListViewClicked(key: String) {
        self.forwardSearch(text: key)
    }
    
    func ynSearchListViewClicked(object: Any) {
        
        
    }
    
    
    // 搜索点击
    func ynSearchListView(_ ynSearchListView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let ynmodel = self.ynSearchView.ynSearchListView.searchResultDatabase[indexPath.row] as? YNSearchModel, let key = ynmodel.key {
            // Call listview clicked based on key
            self.ynSearchView.ynSearchListView.ynSearchListViewDelegate?.ynSearchListViewClicked(key: key)
            
            // return object you set in database
            self.ynSearchView.ynSearchListView.ynSearchListViewDelegate?.ynSearchListViewClicked(object: self.ynSearchView.ynSearchListView.database[indexPath.row])
            
            // Append into Search history if key not exsit
            if !(self.ynSearch.getSearchHistories()?.contains(key))!{
                self.ynSearchView.ynSearchListView.ynSearch.appendSearchHistories(value: key)
            }
        }
        
        
    }
    
    
    
    // 搜索显示列表
    func ynSearchListView(_ ynSearchListView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.ynSearchView.ynSearchListView.dequeueReusableCell(withIdentifier: YNSearchListViewCell.ID)
            as! YNSearchListViewCell
        
        if let ynmodel = self.ynSearchView.ynSearchListView.searchResultDatabase[indexPath.row] as? YNSearchModel {
            cell.searchLabel.text = ynmodel.key
        }
        
        return cell
    }
    
    
}
