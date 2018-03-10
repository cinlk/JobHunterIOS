//
//  PrivacyCellView.swift
//  internals
//
//  Created by ke.liang on 2018/2/23.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let InneralCellHeight:CGFloat = 20
fileprivate let subTableH:CGFloat = 0
fileprivate let subTableFootH:CGFloat = 30



class privacyModel:NSObject{
    
    var title:String
    var selected:Bool
    var showCompany:Bool
    init(title:String, selected:Bool, showCompany:Bool) {
        self.title = title
        self.selected = selected
        self.showCompany = showCompany
    }
}


protocol changeItems: class {
    
    func reloadCell(at index :Int)
    func addCompany()
    
}


fileprivate let imgSize:CGSize = CGSize.init(width: 25, height: 25)

@objcMembers class PrivacyCellView: UITableViewCell {

    
    private let pdata = privacyInfo.shared
    
    weak var delegate:changeItems?
    
    
    private lazy var title:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - imgSize.width - 20)
        return label
    }()
    
    private lazy var icon:UIImageView = {
        let img = UIImageView.init(frame: CGRect.zero)
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    // 嵌套tableview 存储屏蔽的公司名单
    lazy var subItem:UITableView = { [unowned self] in
        let table = UITableView.init(frame: CGRect.zero, style: .plain)
        table.backgroundColor = UIColor.init(r: 234, g: 234, b: 266)
        let btn = UIButton.init(frame: CGRect.zero)
        btn.setTitle("添加", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = UIColor.blue
        btn.addTarget(self, action: #selector(addCompany), for: .touchUpInside)
        table.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: subTableFootH))
        
        table.tableFooterView?.addSubview(btn)
        _ = btn.sd_layout().leftSpaceToView(table.tableFooterView,TableCellOffsetX)?.widthIs(100)?.bottomSpaceToView(table.tableFooterView,5)?.topSpaceToView(table.tableFooterView,5)
        
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.isScrollEnabled = false
        return table
        
    }()
    
   dynamic var mode:privacyModel?{
        didSet{
            self.title.text = mode?.title
            setIcon(flag: mode!.selected)
            
            if mode!.showCompany{
                self.subItem.isHidden = false
                // 用约束会产生奇怪的tableview index错误？？ 直接用frame
                subItem.frame = CGRect.init(x: 0, y: 35, width: ScreenW, height: subTableFootH + CGFloat(pdata.getCompanys().count)*InneralCellHeight)
                self.setupAutoHeight(withBottomView: subItem, bottomMargin: 10)
            }else{
                self.subItem.isHidden = true
                self.setupAutoHeight(withBottomView: title, bottomMargin: 10)
            }
        }
       
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    class func identity()->String{
        return "PrivacyCellView"
    }
    
    
}


// 添加公司代理
extension PrivacyCellView{
    
    @objc func addCompany(sender:UIButton){

        self.delegate?.addCompany()
    }
}


extension PrivacyCellView{
    
    
    private func initView(){
        let views:[UIView] = [title, icon, subItem]
        self.contentView.sd_addSubviews(views)
        self.selectionStyle = .none
        self.layer.masksToBounds = true
        
        _ = title.sd_layout().leftSpaceToView(self.contentView,TableCellOffsetX)?.topSpaceToView (self.contentView,10)?.autoHeightRatio(0)
        _ = icon.sd_layout().rightSpaceToView(self.contentView,10)?.topEqualToView(title)?.widthIs(imgSize.width)?.heightIs(imgSize.height)
        //  用约束会产生奇怪的tableview index错误？？ 直接用frame
        subItem.frame = CGRect.init(x: 0, y: 35, width: ScreenW, height: subTableFootH + CGFloat(pdata.getCompanys().count)*InneralCellHeight)
        
        title.setMaxNumberOfLinesToShow(1)
        
    }
    
    //
    private func setIcon(flag: Bool){
        if flag{
            self.icon.image = #imageLiteral(resourceName: "checked")
            
        }else{
            self.icon.image = #imageLiteral(resourceName: "round")
        }
        self.icon.sizeToFit()
    }
    
    // icon 和subitem能点击
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let iconP = self.contentView.convert(point, to: self.icon)
        let itemP = self.contentView.convert(point, to: self.subItem)
        if self.icon.point(inside: iconP, with: event){
            return super.hitTest(point, with: event)
        }else if self.subItem.point(inside: itemP, with: event){
            return super.hitTest(point, with: event)
        }
        
        return nil
    }
}


// 有删除完元素 在加载 有bug？？？

extension PrivacyCellView:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("---- \(pdata.getCompanys().count)")
        return pdata.getCompanys().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        print("++++ \(indexPath)")
        cell.textLabel?.text = pdata.getCompanys()[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.textColor = UIColor.lightGray
        cell.backgroundColor = UIColor.clear
        let deletedBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 15))
        deletedBtn.setTitle("删除", for: .normal)
        deletedBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        deletedBtn.setTitleColor(UIColor.blue, for: .normal)
        deletedBtn.tag = indexPath.row
        deletedBtn.addTarget(self, action: #selector(deletedItem), for: .touchUpInside)
        cell.accessoryView = deletedBtn
        cell.selectionStyle = .none
        return cell 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return InneralCellHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

extension PrivacyCellView{
    
    @objc func deletedItem(btn:UIButton){
        let row = btn.tag
        pdata.deleteCompany(index: row)
        self.subItem.reloadData()
        self.delegate?.reloadCell(at: 2)
    }
}



