//
//  personCardVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


fileprivate let tableHeaderH:CGFloat = 200
fileprivate let sectionTitle:[String] = ["实习/项目经历","教育经历"]
fileprivate let sectionH:CGFloat = 40
fileprivate let shareViewH:CGFloat = 200

class personCardVC: UITableViewController {

    
    private var pManager:personModelManager = personModelManager.shared
    
    // 头部view
    private lazy var tbHeader:personTableHeader  = {  [unowned self] in
        let th = personTableHeader.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: tableHeaderH))
        th.isHR = false
        th.avatarImg.image = UIImage.init(named: (self.pManager.personBaseInfo?.tx)!)
        th.nameTitle.text = self.pManager.personBaseInfo?.name
        th.introduce.text = self.pManager.educationInfos[0].colleage + "-" +
                            self.pManager.educationInfos[0].department
        return th
    }()
    
    // 自定义barview
    private lazy var navBarTitleView:UIView = { [unowned self] in
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: 64))
        v.backgroundColor = UIColor.orange
        v.alpha = 0
        let title = UILabel.init(frame: CGRect.zero)
        title.textAlignment = .center
        title.text = self.pManager.personBaseInfo?.name
        title.font = UIFont.systemFont(ofSize: 16)
        title.sizeToFit()
        v.addSubview(title)
        _ = title.sd_layout().centerXEqualToView(v)?.topSpaceToView(v,25)?.bottomSpaceToView(v,10)
        return v
    }()
    
    private lazy var shareButton:UIButton = { [unowned self] in
        let share = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        share.setImage( UIImage.barImage(size: CGSize.init(width: 30, height: 30), offset: CGPoint.zero, renderMode: .alwaysOriginal, name: "share"),for: .normal)
        share.clipsToBounds = true
        share.backgroundColor = UIColor.clear
        share.addTarget(self, action: #selector(shared), for: .touchUpInside)
        return share
    }()
    
    // 背景view
    private lazy var backgroundView:UIView = {
        let back = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: ScreenH))
        let tap = UITapGestureRecognizer.init()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: #selector(hiddenBackView(_:)))
        back.backgroundColor = UIColor.init(r: 0.5, g: 0.5, b: 0.5, alpha: 0.5)
        back.addGestureRecognizer(tap)
        return back
    }()
   // 分享界面
    private lazy var MyshareView:shareView = {
        let s = shareView.init(frame: CGRect.init(x: 0, y: ScreenH, width: ScreenW, height: shareViewH))
        UIApplication.shared.windows.last?.addSubview(s)
        return s
    }()
    
    private var shareOriginY:CGFloat = 0
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        loadData()
        setTableHeaderView()
        setNavigationView()
        setShare()
        self.tableView.separatorStyle = .singleLine
        self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 60, right: 0)
        self.tableView.register(cardCell.self, forCellReuseIdentifier: cardCell.identity())
      
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.tableView.contentInsetAdjustmentBehavior = .never
         self.navigationController?.navigationBar.settranslucent(true)
 
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.settranslucent(false)
        navBarTitleView.removeFromSuperview()
        self.navigationController?.view.willRemoveSubview(navBarTitleView)
       


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
         return sectionTitle.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        switch section {
        case 0:
            return pManager.projectInfo.count
        case 1:
            return pManager.educationInfos.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cardCell.identity(), for: indexPath) as! cardCell
        switch indexPath.section {
        case 0:
            
            let item = pManager.projectInfo[indexPath.row]
            let mode:cardModel =  cardModel.init(time: item.startTime + " 到 " + item.endTime, middle: item.company, bottom: item.position)
            cell.mode = mode
            cell.useCellFrameCache(with: indexPath, tableView: tableView)
            return cell
        case 1:
            let item = pManager.educationInfos[indexPath.row]
            let mode = cardModel.init(time: item.startTime + " 到 " + item.endTime, middle: item.colleage, bottom: item.department + "-" + item.degree)
            cell.useCellFrameCache(with: indexPath, tableView: tableView)
            cell.mode = mode
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            let item = pManager.projectInfo[indexPath.row]
            let mode:cardModel =  cardModel.init(time: item.startTime + " 到 " + item.endTime, middle: item.company, bottom: item.position)
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: cardCell.self, contentViewWidth: ScreenW)
        case 1:
            let item = pManager.educationInfos[indexPath.row]
            let mode = cardModel.init(time: item.startTime + " 到 " + item.endTime, middle: item.colleage, bottom: item.department + "-" + item.degree)
            return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: cardCell.self, contentViewWidth: ScreenW)
            
        default:
            return 0
        }
        
       
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let v = UIView.init(frame: CGRect.init(x: 10, y: 15, width: ScreenW, height: 0))
        v.backgroundColor = UIColor.white
        let title = UILabel.init(frame: CGRect.zero)
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.textColor = UIColor.black
        title.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        title.text = sectionTitle[section]
        let underLine:UIView = UIView.init(frame: CGRect.zero)
        underLine.backgroundColor = UIColor.lightGray
        let backV:UIView = UIView.init(frame: CGRect.zero)
        backV.backgroundColor = UIColor.lightGray
        
        v.addSubview(backV)
        _ = backV.sd_layout().leftEqualToView(v)?.rightEqualToView(v)?.topEqualToView(v)?.heightIs(5)
        title.sizeToFit()
        v.addSubview(title)
        _ = title.sd_layout().leftSpaceToView(v,10)?.topSpaceToView(backV,5)?.autoHeightRatio(0)
        v.addSubview(underLine)
        _ = underLine.sd_layout().leftEqualToView(v)?.rightEqualToView(v)?.bottomEqualToView(v)?.heightIs(1)
        v.setupAutoHeight(withBottomView: underLine, bottomMargin: 0)
        
        return v
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionH
    }
}


extension personCardVC{
    
    private func setNavigationView(){
        
        self.navigationController?.view.insertSubview(navBarTitleView, at: 1)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: shareButton)
        
        
    }
    
    private func setTableHeaderView(){
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        self.tableView.tableHeaderView = tbHeader
        
        
    }
    @objc func hiddenBackView(_ gest: UITapGestureRecognizer){
        if gest.state == .ended{
            backgroundView.removeFromSuperview()
            self.navigationController?.view.willRemoveSubview(backgroundView)
            UIView.animate(withDuration: 0.4, animations: {
                self.MyshareView.origin.y = self.shareOriginY
            })
        }
    }
    
    
    // 分享界面
    @objc func shared(){
        
        self.navigationController?.view.addSubview(backgroundView)
        UIView.animate(withDuration: 0.4, animations: {
            self.MyshareView.frame = CGRect.init(x: 0, y: ScreenH - shareViewH, width: ScreenW, height: shareViewH)
        })
    }
    
    @objc func sharedClick(_ btn:UIButton){
        print(btn.tag)
    }
    
    private func setShare(){
        shareOriginY = MyshareView.origin.y
        for btn in  MyshareView.itemButtons!{
            btn.addTarget(self, action: #selector(sharedClick(_:)), for: .touchUpInside)
        }
        
    }
}


extension personCardVC{
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        // 显示title
        if offsetY > tableHeaderH - 64{
            navBarTitleView.alpha = 1
        }else{
            navBarTitleView.alpha = 0
            // 禁止向下滑动
            if offsetY < 0 {
                scrollView.contentOffset.y =  0
            }
        }
       
    }
    

}

extension personCardVC{
    // 通过网络获取数据
    private func loadData(){
        pManager.initialData()
    }
}



