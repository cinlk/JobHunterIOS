//
//  ShowApplyJobsView.swift
//  internals
//
//  Created by ke.liang on 2018/6/16.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit



protocol showApplyJobsDelegate: class {
    
    func apply(view:ShowApplyJobsView, jobIndex:Int)
    
}


private class topView:UIView {
    
    internal var pv:ShowApplyJobsView?
    
    private lazy var selecTitle:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.setSingleLineAutoResizeWithMaxWidth(160)
        label.text = "选择职位"
        return label
        
    }()
    
    private lazy var cancelBtn:UIButton = {
        let btn  = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self.pv!, action: #selector(self.pv!.cancel), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var line:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    
    convenience init(frame:CGRect ,v:ShowApplyJobsView){
        self.init(frame: frame)
        self.pv = v
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let views:[UIView] = [selecTitle, cancelBtn, line]
        self.sd_addSubviews(views)
        _ = selecTitle.sd_layout().topSpaceToView(self,10)?.leftSpaceToView(self,10)?.autoHeightRatio(0)
        _ = cancelBtn.sd_layout().rightSpaceToView(self,10)?.topEqualToView(selecTitle)?.widthIs(40)?.heightRatioToView(selecTitle,0.8)
        _ = line.sd_layout().topSpaceToView(selecTitle,5)?.leftEqualToView(self)?.rightEqualToView(self)?.heightIs(1)
        
        selecTitle.setMaxNumberOfLinesToShow(1)
        self.setupAutoHeight(withBottomView: line, bottomMargin: 0)
    }
    
}

fileprivate let cellIdentity:String = "cell"
fileprivate let cellH:CGFloat = 40
fileprivate let maxRow:Int = 7

class ShowApplyJobsView: UIView {

    
    private lazy var  tv:topView = {
        let v = topView.init(frame: CGRect.zero, v: self)
        return v
    }()
    
    private lazy var contentTable:UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.white
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentity)
        return table
    }()
    
    private lazy var bottomBtn:UIButton = {
        let btn  = UIButton()
        btn.setTitle("投递简历", for: .normal)
        btn.backgroundColor = UIColor.blue
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(apply), for: .touchUpInside)
        return btn
    }()
    
    
    
    private lazy var showJobsBackGround:UIButton = {
        let btn = UIButton(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH))
        btn.backgroundColor = UIColor.lightGray
        btn.alpha = 0.5
        btn.addTarget(self, action: #selector(hidden), for: .touchUpInside)
        return btn
    }()
    
    
    
    
    private lazy var selectIndex:Int = -1
    
    weak var delegate:showApplyJobsDelegate?
    
    
    internal var jobs:[String] = []{
        didSet{
            self.contentTable.reloadData()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension ShowApplyJobsView{
    
    private func setView(){
        self.backgroundColor = UIColor.white

        let views:[UIView] =  [tv, contentTable, bottomBtn]
        self.sd_addSubviews(views)
        //self.autoresizingMask = [.]
        self.clipsToBounds = true
        
    }
    
    override func layoutSubviews() {
        _ = tv.sd_layout()?.topEqualToView(self)?.leftEqualToView(self)?.rightEqualToView(self)
        
        _ = bottomBtn.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)?.heightIs(40)
        
        _ = contentTable.sd_layout().topSpaceToView(tv,0)?.leftEqualToView(self)?.rightEqualToView(self)?.bottomSpaceToView(bottomBtn,0)
        
        super.layoutSubviews()
        
    }
}



extension ShowApplyJobsView: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: cellIdentity, for: indexPath)
        cell.textLabel?.text =  jobs[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.textColor =  indexPath.row == selectIndex ? UIColor.blue : UIColor.black
        cell.accessoryType =  indexPath.row == selectIndex ?  .checkmark : .none
        
        return cell
       
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellH
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.blue
        }
        selectIndex = indexPath.row

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.black
        }
    }
    
    
    
    
}

extension ShowApplyJobsView{
    
    @objc private func apply(){
        if selectIndex == -1 {
            return
        }
        
        delegate?.apply(view: self, jobIndex: selectIndex)
        self.hidden()
    }
    
    @objc internal func cancel(){
        self.hidden()
        
    }
    
    
    open func show(){
       
        UIApplication.shared.keyWindow?.insertSubview(showJobsBackGround , belowSubview: self)
        
        // TODO  tv 的高度不能获取, 给出手动计算的值
        
        let height = CGFloat(min(jobs.count, maxRow)) * cellH + self.bottomBtn.frame.height + 36
        //print(self.bottomBtn.frame.height, self.tv.frame.height)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.frame = CGRect.init(x: 0, y: GlobalConfig.ScreenH - height, width: GlobalConfig.ScreenW, height: height)
        }, completion: nil)
        
    }
    
    @objc open func hidden(){
        showJobsBackGround.removeFromSuperview()
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.frame = CGRect.init(x: 0, y: GlobalConfig.ScreenH, width: GlobalConfig.ScreenW, height: 0)
        }, completion: nil)
        
        
    }
}
