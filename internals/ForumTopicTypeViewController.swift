//
//  ForumTopicTypeViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let titleName:String = "选择板块"

class ForumTopicTypeViewController: UITableViewController {

    
    private let datas:[forumType] = forumType.items
    internal var getType:((_ type:forumType)->Void)?
    
    // currentSelect
    private var currentIndex:Int = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleName
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = UIColor.viewBackColor()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.removeCustomerView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell"){
            cell.textLabel?.text = datas[indexPath.row].describe
            cell.selectionStyle = .none
            if indexPath.row ==  currentIndex{
                cell.accessoryType = .checkmark
                cell.textLabel?.textColor = UIColor.blue
            }else{
                cell.accessoryType = .none
                cell.textLabel?.textColor = UIColor.black

            }
            return cell
        }
        return UITableViewCell()
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currentIndex = indexPath.row
        self.getType?(datas[indexPath.row])
        self.navigationController?.popViewController(animated: true)
        tableView.reloadData()
     }
    
    

    
    
    
    
    

}
