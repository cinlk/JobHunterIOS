//
//  ScrollerNewsCell.swift
//  internals
//
//  Created by ke.liang on 2018/4/15.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class ScrollerNewsCell: UITableViewCell {

    
    
    private var timer:Timer?
    private var pickerDataSize = 120_000
    private var count = 0

    // 个数大于2 且是2的整数倍
    var mode:[String]?{
        didSet{
            
            // 插入第一个位置，滚到这里切换到底部
            
            _ = self.scroller.sd_layout().heightIs( CGFloat(2 * 25) )
            self.scroller.reloadData()
 
//
            // 开始无限滚动
            self.startScheduler()
            
            
            
            
        }
    }
    private lazy var leftImage:UIImageView = {
        let img = UIImageView.init(image: UIImage.init(named: "news"))
        img.clipsToBounds = true
        img.contentMode = .scaleToFill
        return img
    }()
    
    private lazy var scroller:UITableView = { [unowned self] in
        let table = UITableView()
        table.dataSource = self
        table.delegate = self
        table.isScrollEnabled = false
        table.tableHeaderView = UIView()
        table.tableFooterView = UIView()
        table.separatorStyle = .none
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isUserInteractionEnabled = false
        return table

    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        
        self.contentView.addSubview(leftImage)
        //self.contentView.addSubview(pickView)
        self.contentView.addSubview(scroller)
        _ = leftImage.sd_layout().leftSpaceToView(self.contentView,10)?.topEqualToView(self.contentView)?.bottomEqualToView(self.contentView)?.widthIs(45)
        _ = scroller.sd_layout().leftSpaceToView(leftImage,10)?.rightEqualToView(self.contentView)?.centerYEqualToView(self.contentView)?.heightIs(0)
        
       
    }
    
    
    class func identitiy()->String{
        return "ScrollerNewsCell"
    }
    
    class func cellheight()->CGFloat{
        return 50
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.stopScheduler()
    }
}

extension ScrollerNewsCell{
    private func startScheduler(){
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { [unowned self] (time) in
                
                // 模拟无限循环 pickerDataSize 数很大时
                if self.count <= self.pickerDataSize{
                    self.count += 2
                    self.scroller.scrollToRow(at: IndexPath.init(row: self.count, section: 0), at: UITableViewScrollPosition.none, animated: true)
                    // 重置
                    if self.count == self.pickerDataSize{
                        self.count = 0
                    }
                    
                }
            })
            RunLoop.current.add(self.timer!, forMode: .commonModes)

        }
    }
    
    private func stopScheduler(){
        self.timer?.invalidate()
        self.timer = nil
    }
}


extension ScrollerNewsCell: UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickerDataSize
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = mode![indexPath.row % mode!.count]
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  25
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("----\(indexPath)")
    }

    
    
}
