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
fileprivate let sectionH:CGFloat = 50



class personCardVC: UITableViewController {

    
    private var pManager:personModelManager = personModelManager.shared
    private lazy var tbHeader:personTableHeader  = {  [unowned self] in
        let th = personTableHeader.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: tableHeaderH))
        th.isHR = false
        th.avatarImg.image = UIImage.init(named: (self.pManager.personBaseInfo?.tx)!)
        th.nameTitle.text = self.pManager.personBaseInfo?.name
        th.introduce.text = self.pManager.educationInfos[0].colleage + "-" +
                            self.pManager.educationInfos[0].department
        
        return th
    }()
    
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
    
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setTableHeaderView()
        setNavigationView()
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
        print("disapear  card \(self.navigationController?.navigationBar.isTranslucent)")
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
            cell.mode = (item.startTime + " 到 " + item.endTime, item.company, item.position)
            return cell
        case 1:
            let item = pManager.educationInfos[indexPath.row]
            cell.mode = (item.startTime + " 到 " + item.endTime, item.colleage, item.department + "-" + item.degree)
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cardCell.ceilHeight()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: sectionH))
        v.backgroundColor = UIColor.white
        let title = UILabel.init(frame: CGRect.zero)
        title.font = UIFont.systemFont(ofSize: 16)
        title.textColor = UIColor.black
        title.text = sectionTitle[section]
        let underLine:UIView = UIView.init(frame: CGRect.zero)
        underLine.backgroundColor = UIColor.lightGray
        let backV:UIView = UIView.init(frame: CGRect.zero)
        backV.backgroundColor = UIColor.lightGray
        v.addSubview(backV)
        _ = backV.sd_layout().leftEqualToView(v)?.rightEqualToView(v)?.topEqualToView(v)?.heightIs(5)
        title.sizeToFit()
        v.addSubview(title)
        _ = title.sd_layout().leftSpaceToView(v,10)?.topSpaceToView(backV,5)?.bottomSpaceToView(v,5)?.rightSpaceToView(v,10)
        v.addSubview(underLine)
        _ = underLine.sd_layout().leftEqualToView(v)?.rightEqualToView(v)?.bottomEqualToView(v)?.heightIs(1)
        
        
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
    
    @objc func shared(){
        
    }
}


extension personCardVC{
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
       
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




