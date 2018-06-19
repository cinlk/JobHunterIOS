//
//  GraduateJobsViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import ObjectMapper
import YNDropDownMenu


class GraduateJobsViewController: BasePositionItemViewController {


    private var datas:[CompuseRecruiteJobs] = []
    
    
    
    
    // 自定义条件选择下拉菜单view
    lazy var myDropMenu: YNDropDownMenu = { [unowned self] in
        
        
        let menu = YNDropDownMenu.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: dropMenuH), dropDownViews: [cityMenu,careerClassify,degree], dropDownViewTitles: ["城市","行业分类","学历"])
        
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
        
        // 筛选回调
        careerClassify.passData = { business in
            print(business)
            self.myDropMenu.changeMenu(title: business, at: 1)
        }
        
        cityMenu.passData = { citys in
           // print(citys)
        }
        
        degree.passData = { kind in
            print(kind)
            self.myDropMenu.changeMenu(title: kind, at: 2)
        }
        
        
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


extension GraduateJobsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: CommonJobTableCell.identity(), for: indexPath) as! CommonJobTableCell
        cell.mode = self.datas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: false)
        let mode = self.datas[indexPath.row]
        let graduateJob = JobDetailViewController()

        graduateJob.kind = (id: mode.id!, type: mode.kind!)
        
        graduateJob.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(graduateJob, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = self.datas[indexPath.row]
        return table.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CommonJobTableCell.self, contentViewWidth: ScreenW)
        
    }
    
    
}

extension GraduateJobsViewController{
    
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async {  [weak self] in
            Thread.sleep(forTimeInterval: 3)
            for _ in 0..<20{
                
                self?.datas.append(Mapper<CompuseRecruiteJobs>().map(JSON: ["id":"dwqdqwd","icon":"swift","companyID":"dqwd-dqwdqwddqw","name":"码农","company":["id":"dqwd","name":"公司名称","isCollected":false,"icon":"chrome","address":["地址1","地址2"],"industry":["行业1","行业2"],"staffs":"1000人以上"],"hr":["userID":"dqwd","name":"我是hr","position":"HRBP","ontime": Date().timeIntervalSince1970 - TimeInterval(6514),"icon": #imageLiteral(resourceName: "jing").toBase64String()],"address":["北京","地址2"],"create_time":Date().timeIntervalSince1970,"education":"本科","type":"graduate","isTalked":false,"isValidate":true,"isCollected":false,"isApply":false,"readNums":arc4random()%1000])!)
                
            }
            
            
            
            DispatchQueue.main.async {
                
                self?.didFinishloadData()
            }
        }
    }
}
