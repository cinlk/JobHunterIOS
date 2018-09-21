//
//  ForumMessageVC.swift
//  internals
//
//  Created by ke.liang on 2018/7/2.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class ForumMessageVC: UIViewController {

    private lazy var table:UITableView = { [unowned self] in
        let tb = UITableView()
        tb.dataSource = self
        tb.delegate = self
        tb.tableFooterView = UIView()
        tb.separatorStyle = .singleLine
        tb.backgroundColor = UIColor.viewBackColor()
        tb.register(itemCell.self, forCellReuseIdentifier: itemCell.identity())
        return tb
    }()
    
    
    private lazy var modes:[(UIImage, String)] = [(#imageLiteral(resourceName: "selectedthumbup"),"赞"),(#imageLiteral(resourceName: "commentMessage"),"回复我的"),(#imageLiteral(resourceName: "commentMessage"),"我的回复")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(table)
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

}

extension ForumMessageVC: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: itemCell.identity(), for: indexPath) as? itemCell{
            cell.mode = modes[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return itemCell.cellHeight()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 0{
            let thumb = ThumbUPVC()
            thumb.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(thumb, animated: true)
        }
        else if indexPath.row == 1{
            let mycomment = ReplyToMeVC()
            mycomment.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(mycomment, animated: true)
        }else if indexPath.row == 2{
            let replyMe = MyCommentVC()
            replyMe.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(replyMe, animated: true)
        }
    }
    
    
    
}

// 图片的文本cell

fileprivate class itemCell:TitleTableViewCell{
    
    
    internal var mode:(image:UIImage, name:String)?{
        didSet{
            guard let mode = mode  else {
                return
            }
            
            self.icon.image = mode.image
            self.iconName.text = mode.name
            
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.line.isHidden = true
        icon.sd_resetNewLayout()
        iconName.sd_resetNewLayout()
        
        _ = icon.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(40)?.heightIs(40)
        _ = iconName.sd_layout().leftSpaceToView(icon,10)?.centerYEqualToView(icon)?.autoHeightRatio(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String{
        return "itemCell"
    }
    
    class func cellHeight()->CGFloat{
        return 50
    }
}
