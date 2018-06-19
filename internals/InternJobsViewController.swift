//
//  InternJobsViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper
import YNDropDownMenu


class InternJobsViewController: BasePositionItemViewController {

    private var datas:[CompuseRecruiteJobs] = []
    
    
    lazy var myDropMenu: YNDropDownMenu = { [unowned self] in
        
        
        let menu = YNDropDownMenu.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: dropMenuH), dropDownViews: [cityMenu,careerClassify,internCondition], dropDownViewTitles: ["城市","行业分类","实习条件"])
        
        menu.setImageWhen(normal: UIImage(named: "arrow_nor"), selected: UIImage(named: "arrow_xl"), disabled: UIImage(named: "arrow_dim"))
        menu.setLabelColorWhen(normal: .black, selected: .blue, disabled: .gray)
        
        menu.setLabelFontWhen(normal: .systemFont(ofSize: 16), selected: .boldSystemFont(ofSize: 16), disabled: .systemFont(ofSize: 16))
        menu.backgroundBlurEnabled = true
        menu.blurEffectViewAlpha = 0.5
        menu.showMenuSpringWithDamping = 1
        menu.hideMenuSpringWithDamping = 1
        menu.bottomLine.isHidden = false
        
        menu.addSwipeGestureToBlurView()
        return menu
        
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        loadData()
       
        // Do any additional setup after loading the view.
    }
    
    override func setViews() {
        dropMenu.removeFromSuperview()
        
        self.view.addSubview(myDropMenu)
        
        table.register(CommonJobTableCell.self, forCellReuseIdentifier: CommonJobTableCell.identity())
        table.dataSource = self
        table.delegate = self
        self.handleViews.append(myDropMenu)
        
        // 设置menu
        super.setViews()
        
        // 筛选回调
        cityMenu.passData = { citys in
            //print(citys)
        }
        
        careerClassify.passData = { kind in
            print(kind)
            self.myDropMenu.changeMenu(title: kind, at: 1)
        }
        
        internCondition.passData = { condition in
            //print(condition)
        }
        
        
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
        self.table.reloadData()
    }
    
    override func reload() {
        super.reload()
        self.loadData()
    }
    
    
    // MARK
    override func sendRequest() {
        self.datas.removeAll()
        self.table.reloadData()
    }


}

extension InternJobsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: CommonJobTableCell.identity(), for: indexPath) as! CommonJobTableCell
        cell.showTag = false
        
        cell.mode = self.datas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: false)
        let mode = self.datas[indexPath.row]
        let internJob = JobDetailViewController()
        internJob.kind = (id: mode.id!, type: mode.kind!)
        internJob.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(internJob, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = self.datas[indexPath.row]
        return table.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CommonJobTableCell.self, contentViewWidth: ScreenW)
        
    }
    
}

extension InternJobsViewController{
    
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async {  [weak self] in
            Thread.sleep(forTimeInterval: 3)
            for _ in 0..<20{
                
                if let data = Mapper<CompuseRecruiteJobs>().map(JSON: ["id":"dwqdqwd","icon":"swift","companyID":"dqwd-dqwdqwddqw","name":"码农","company":["id":"dqwd","name":"公司名称","isCollected":false,"icon":"chrome","address":["地址1","地址2"],"industry":["行业1","行业2"],"staffs":"1000人以上"],"address":["北京","地址2"],"create_time":Date().timeIntervalSince1970,"education":"本科","type":"intern","isTalked":false,"isValidate":true,"isCollected":false,"isApply":false,"readNums":arc4random()%1000]){
                    self?.datas.append(data)
                    
                }
                
                
            }
            
            
            
            DispatchQueue.main.async {
                
                self?.didFinishloadData()
            }
        }
    }
}
