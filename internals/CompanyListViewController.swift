//
//  CompanyListViewController.swift
//  internals
//
//  Created by ke.liang on 2018/4/21.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import YNDropDownMenu


class CompanyListViewController: BasePositionItemViewController {

    
    private var datas:[CompanyModel] = []
    
    
    // 自定义条件选择下拉菜单view
    lazy var myDropMenu: YNDropDownMenu = { [unowned self] in
        
        
        let menu = YNDropDownMenu.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: dropMenuH), dropDownViews: [cityMenu,careerClassify], dropDownViewTitles: ["城市","行业分类"])
        
        menu.setImageWhen(normal: UIImage(named: "arrow_nor"), selected: UIImage(named: "arrow_xl"), disabled: UIImage(named: "arrow_dim"))
        menu.setLabelColorWhen(normal: .black, selected: .blue, disabled: .gray)
        
        menu.setLabelFontWhen(normal: .systemFont(ofSize: 16), selected: .boldSystemFont(ofSize: 16), disabled: .systemFont(ofSize: 16))
        menu.backgroundBlurEnabled = true
        menu.blurEffectViewAlpha = 0.5
        menu.showMenuSpringWithDamping = 1
        menu.hideMenuSpringWithDamping = 1
        menu.bottomLine.isHidden = false
        
        return menu
        
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        loadData()
        print("公司")
        // Do any additional setup after loading the view.
        // 筛选回调
        cityMenu.passData = { citys in
            //print(citys)
            
        }
        careerClassify.passData = { industry in
            print(industry)
            self.myDropMenu.changeMenu(title: industry, at: 1)
        }
    }
    
    
    override func setViews() {
        dropMenu.removeFromSuperview()
        
        table.register(CompanyItemCell.self, forCellReuseIdentifier: CompanyItemCell.identity())
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

extension CompanyListViewController:UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CompanyItemCell.identity(), for: indexPath) as! CompanyItemCell
        cell.mode = self.datas[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let mode = self.datas[indexPath.row]
        let companyVC = CompanyMainVC()
        companyVC.mode = mode
        companyVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(companyVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = self.datas[indexPath.row]
        return tableView.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: CompanyItemCell.self, contentViewWidth: ScreenW)
        
    }
}

extension CompanyListViewController{
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Thread.sleep(forTimeInterval: 3)
            for _ in 0..<20{
                self?.datas.append(CompanyModel(JSON: ["id":"dqw-dqwd","name":"公司名",
                                                        "describe":"大哇多无多首先想到的肯定是结束减速的代理方法：scrollViewDscrollViewDidEndDecelerating代理方法的，如果做过用3个界面+scrollView实现循环滚动展示图片，那么基本上都会碰到这么问题。如何准确的监听翻页？我的解决的思路如下达瓦大文大无大无多无大无大无多哇大无多无飞啊飞分为飞飞飞达瓦大文大无大无多哇付达瓦大文大无付多无dwadwadadawdawde吊袜带挖多哇建外大街文档就frog忙不忙你有他们今天又摸排个人票买房可免费课时费\n个人个人，二哥，二\n吊袜带挖多，另外的码问了；吗\n","address":["地址1","地址2"],"icon":"sina","type":["教育","医疗","化工"],"webSite":"https://www.baidu.com","tags":["标签1","标签1测试","标签89我的当前","当前为多","迭代器","群无多当前为多群当前","达瓦大群无多", "当前为多当前的群","当前为多无", "当前为多群无多","杜德伟七多"],"isValidate":true,"isCollected":false])!)
                
                
                
            }
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
        }
    }
}

