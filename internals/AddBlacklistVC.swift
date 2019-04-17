//
//  AddBlacklistVC.swift
//  internals
//
//  Created by ke.liang on 2018/7/11.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


protocol companyBlackDelegate: class {
    func updateBlacklist(lists:[BlackistCompanyModel])
}

fileprivate let cellH:CGFloat = 40
fileprivate let maxBlackCount:Int = 10

class AddBlacklistVC: UIViewController {
    
    
    weak var delegate:companyBlackDelegate?
    
    
    private lazy var searchBar:SearchBarView = {
        let search = SearchBarView.init(frame: CGRect.zero)
        search.placeholder = "输入屏蔽公司名称"
        search.delegate = self
        return search
    }()
    // 引用searchbar的 取消btn，保存一直enable
    private  var cancelBtn:UIButton?

    
    // 包裹searchbar View (设置titleview 能调整位置)
    private lazy var wrapperSearchBar:UIView = {
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW - 10, height: GlobalConfig.searchBarH))
        v.addSubview(searchBar)
        searchBar.frame = v.frame
        return v
    }()
    
    // 搜索结果table
    private lazy var table:UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.backgroundColor = UIColor.white
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    
    private lazy var showWord:Bool = false
    
    // 当前搜索条目显示
    private var searchTinter:String = ""{
        didSet{
            
            showWord = true
            self.table.reloadData()
        }
       
    }
    
    // 搜索结果公司数据，（后台与已经屏蔽的公司做匹配，设置validate 值）
    private  var companys:[BlackistCompanyModel] = []
    
    // 保存当前添加的公司
    private lazy var blacklists:[BlackistCompanyModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}


extension AddBlacklistVC{
    private func setView(){
        self.view.backgroundColor = UIColor.white
        self.navigationItem.hidesBackButton = true
        
        cancelBtn = searchBar.value(forKey: "_cancelButton") as? UIButton
        
        self.navigationItem.titleView = wrapperSearchBar
        searchBar.becomeFirstResponder()

        
        self.view.addSubview(table)
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
    }
}


extension AddBlacklistVC: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  showWord ? 1 : companys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textAlignment = .left
        if showWord{
            cell.textLabel?.text = "搜索  \"\(searchTinter)\""
            cell.accessoryView = nil 
        }else{
            let mode = companys[indexPath.row]
            cell.textLabel?.text = mode.companyName
            // 添加btn
            let addBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: cellH))
            if mode.validate!{
                addBtn.setTitle("已添加", for: .normal)
                addBtn.setTitleColor(UIColor.lightGray, for: .normal)
            }else{
                addBtn.setTitle("添加", for: .normal)
                addBtn.setTitleColor(UIColor.red, for: .normal)
                addBtn.addTarget(self, action: #selector(blockCompany), for: .touchUpInside)
            }
            addBtn.titleLabel?.textAlignment = .center
            addBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            addBtn.tag = indexPath.row
            cell.accessoryView = addBtn
        }
    
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellH
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if showWord{
            showCompanys(showWord: false)
            
        }else{
            
            //print(companys[indexPath.row])
        }
    }
}


extension AddBlacklistVC: UISearchBarDelegate{
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
         changeSearchStatus(text: searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // 回传数据
        delegate?.updateBlacklist(lists: self.blacklists)
        
        searchBar.endEditing(true)
        self.navigationController?.popvc(animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard  let text = searchBar.text,  !text.isEmpty else {
            return
        }
        
        showCompanys(showWord: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        changeSearchStatus(text: searchText)
    }
    
}


extension AddBlacklistVC{

    
    private func showCompanys(showWord:Bool){
        self.showWord = showWord
        searchBar.resignFirstResponder()
        cancelBtn?.isEnabled = true
        searchCompany()
        
    }
    
    private func changeSearchStatus(text:String){
        if text.isEmpty {
            searchTinter = ""
            table.isHidden = true
            return
        }
        table.isHidden = false
        searchTinter = text
    }
    
    
    private func searchCompany(){
        // 显示空的table
        companys.removeAll()
        self.table.reloadData()
        
        // 获取数据在显示(加 加载-进度界面)
        DispatchQueue.global(qos: .userInteractive).async { [weak self]  in
            Thread.sleep(forTimeInterval: 1)
            // 获取数据
            for i in 0..<12{
                if let com =  BlackistCompanyModel(JSON: ["companyID":Utils.getUUID(),"companyName":"公司\(i)","validate":false]){
                    self?.companys.append(com)
                }
            }
            
            DispatchQueue.main.async {
                self?.table.reloadData()
            }
        }
        
    }
}


// 添加黑名单
extension AddBlacklistVC{
    @objc private func blockCompany(_ sender: UIButton){
        if blacklists.count + currentBlacklistCount >= maxBlackCount {
            self.view.showToast(title: "最多添加\(maxBlackCount)个", duration: 5, customImage: nil, mode: .text)
            return
        }
        
        let row = sender.tag
        //
        companys[row].validate = true
        blacklists.append(companys[row])
        // 刷新table row
        self.table.reloadRows(at: [IndexPath.init(item: row, section: 0)], with: .automatic)
        
    
    }
}
