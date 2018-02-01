//
//  PersonViewController.swift
//  internals
//
//  Created by ke.liang on 2017/11/24.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit



fileprivate let SectionN = 2
fileprivate let tableHeaderH:CGFloat = ScreenH / 3 

class PersonViewController: UIViewController {

    private lazy var table:UITableView = { [unowned self] in
        let table = UITableView.init(frame: self.view.bounds)
        table.isScrollEnabled = false
        table.tableFooterView = UIView.init()
        table.delegate = self
        table.dataSource = self
        
        return table
    }()
    
    
    private lazy var tableHeader: personTableHeader = {
        let v = personTableHeader.init(frame:CGRect.init(x: 0, y: 0, width: ScreenW, height: tableHeaderH))
        return v
        
    }()
    
    private var mode:[(image:UIImage, title:String)] = [(#imageLiteral(resourceName: "namecard"),"我的名片"),(#imageLiteral(resourceName: "settings"),"账号设置"),(#imageLiteral(resourceName: "collection"),"我的收藏"),(#imageLiteral(resourceName: "feedback"),"意见反馈")]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }

    
    override func viewWillLayoutSubviews() {
        self.view.addSubview(table)
        self.table.tableHeaderView = tableHeader
        
        
    }


}


extension PersonViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionN
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  section == 0 ? 1 : self.mode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell.init()
            cell.textLabel?.text = "我的简历"
            return cell
            
        case 1:
            let cell = UITableViewCell.init()
            cell.textLabel?.text = self.mode[indexPath.row].title
            
            return cell
        default:
            return UITableViewCell.init()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.lightGray
        return view
        
    }
    
    
    
}


private class personTableHeader:UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.backgroundColor = UIColor.orange
        
    }
}
