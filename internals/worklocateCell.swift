//
//  worklocate.swift
//  internals
//
//  Created by ke.liang on 2017/9/5.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit



fileprivate let cellH:CGFloat = 30


@objcMembers  class worklocateCell: TitleTableViewCell {

    
    var chooseAddress:((_ adress:String)->Void)?
    
    private lazy var address:UITableView = {
        let tb = UITableView()
        tb.tableFooterView = UIView()
        tb.backgroundColor = UIColor.white
        tb.dataSource = self
        tb.delegate  = self
        tb.showsVerticalScrollIndicator = false
        return tb
    }()
  
    
    dynamic var mode:[String]?{
        didSet{
            iconName.text = "工作地址"
            
            self.address.reloadData()
            if let num = mode?.count {
               _ =  address.sd_layout().heightIs(CGFloat(num) * cellH)
            }
            self.setupAutoHeight(withBottomView: address, bottomMargin: 0)
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.contentView.addSubview(address)
        
        
        _ = address.sd_layout().topSpaceToView(line,5)?.leftEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.heightIs(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func identity()->String{
        return "worklocateCell"
    }
}

extension worklocateCell: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mode?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.text = mode?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellH
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let address = mode?[indexPath.row]{
            chooseAddress?(address)

        }
        
    }
    
    
}
