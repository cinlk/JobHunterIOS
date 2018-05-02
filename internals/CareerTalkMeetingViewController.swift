//
//  CareerTalkMeetingViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu


class CareerTalkMeetingViewController: BasePositionItemViewController {

    
    private var datas:[CareerTalkMeetingModel] = []
    

    // 自定义条件选择下拉菜单view
    lazy var myDropMenu: YNDropDownMenu = { [unowned self] in
        
        
        let menu = YNDropDownMenu.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: dropMenuH), dropDownViews: [colleges,industryKind,meetingValidate], dropDownViewTitles: ["学校","行业领域","宣讲时间"])
        
        menu.setImageWhen(normal: UIImage(named: "arrow_nor"), selected: UIImage(named: "arrow_xl"), disabled: UIImage(named: "arrow_dim"))
        menu.setLabelColorWhen(normal: .black, selected: .blue, disabled: .gray)
        
        menu.setLabelFontWhen(normal: .systemFont(ofSize: 16), selected: .boldSystemFont(ofSize: 16), disabled: .systemFont(ofSize: 16))
        menu.backgroundBlurEnabled = true
        menu.blurEffectViewAlpha = 0.5
        menu.showMenuSpringWithDamping = 1
        menu.hideMenuSpringWithDamping = 1
        menu.bottomLine.isHidden = false
        menu.bottomLine.backgroundColor = UIColor.black
        return menu
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        loadData()
        print("宣讲会")
        // Do any additional setup after loading the view.
        // 筛选回调
        self.colleges.passData = { colleges in
            print(colleges)
            
        }
        
        industryKind.passData = { kind in
            print(kind)
            self.myDropMenu.changeMenu(title: kind, at: 1)
        }
        meetingValidate.passData = { time in
            print(time)
            self.myDropMenu.changeMenu(title: time, at: 2)
        }
        
    }

    
    override func setViews() {
        dropMenu.removeFromSuperview()
        
        table.register(CareerTalkCell.self, forCellReuseIdentifier: CareerTalkCell.identity())
        table.delegate = self
        table.dataSource = self
        
        self.view.addSubview(myDropMenu)
        self.handleViews.append(myDropMenu)
        
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
    
    override func sendRequest() {
        
    }
    

}


extension CareerTalkMeetingViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CareerTalkCell.identity(), for: indexPath) as! CareerTalkCell
        cell.mode = self.datas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = self.datas[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CareerTalkCell.self, contentViewWidth: ScreenW)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let mode = self.datas[indexPath.row]
        let show = CareerTalkShowViewController()
        show.hidesBottomBarWhenPushed = true
        show.meetingID = mode.id
        self.navigationController?.pushViewController(show, animated: true)
    }
    
    
    
}


extension CareerTalkMeetingViewController{
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Thread.sleep(forTimeInterval: 3)
            for _ in 0..<20{
                self?.datas.append(CareerTalkMeetingModel(JSON: ["id":"dqw-dqwd","companyModel":["id":"com-dqwd-5dq",
                                                                                                 "icon":"sina","name":"公司名字","describe":"达瓦大群-dqwd","isValidate":true,"isCollected":false],
                                                                 "college":"北京大学","address":"教学室二"
                    ,"isValidate":true,"isCollected":false,"icon":"car","start_time":Date().timeIntervalSince1970,
                                                          "name":"北京高华证券有限责任公司宣讲会但钱当前无多群","source":"上海交大",
                                                          "content":"举办方：电院举办时间：2018年4月25日 18:00~20:00  \n举办地点：上海交通大学 - 上海市东川路800号电院楼群3-100会议室 单位名称：北京高华证券有限责任公司 联系方式：专业要求：不限、信息安全类、自动化类、计算机类、电子类、软件工程类"])!)
                
                
            }
            
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
        }
    }
}
