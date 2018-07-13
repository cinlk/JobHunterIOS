//
//  HelpsVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let headerH:CGFloat = 180
fileprivate let itemCGSize:CGSize = CGSize.init(width: ScreenW / 3 , height: headerH / 2 )


class HelpsVC: BaseViewController {

    
    
    private lazy var tableView: UITableView = { [unowned self] in
        let table = UITableView(frame: CGRect.zero, style: .grouped)
        table.delegate = self
        table.dataSource = self
        //table.backgroundColor = UIColor.viewBackColor()
        table.tableFooterView = UIView.init()
        table.register(expansionCell.self, forCellReuseIdentifier: expansionCell.identity())
        return table

    }()
    
    private lazy var  headerView:HeaderCollectionView = {  [unowned self] in
        let v = HeaderCollectionView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: headerH), itemSize: itemCGSize)
        v.backgroundColor = UIColor.clear
        v.delegate = self
        return v
    }()

    
    // 选中的cell
    private var selectedCellIndexPath:[IndexPath] = []
    
    private var mode:HelpAskModel?
    // 顶部view 显示items
    private var shareItems:[ShareItem] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.insertCustomerView(UIColor.orange)
     }
    
    
    
    override func setViews() {
        self.tableView.backgroundColor = UIColor.viewBackColor()
        
        self.view.addSubview(tableView)
        self.title = "帮助中心"
        self.navigationController?.delegate = self
        _ = tableView.sd_layout().topEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
        self.tableView.tableHeaderView = headerView
        self.handleViews.append(tableView)
        super.setViews()
    }
    
    
    override func didFinishloadData() {
        super.didFinishloadData()
        self.headerView.mode = shareItems
        self.tableView.reloadData()
        
    }
    
    override func showError() {
        super.showError()
    }
    
    override func reload() {
        super.reload()
        self.loadData()
    }

}


extension HelpsVC:UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.isKind(of: PersonViewController.self){
            self.navigationController?.removeCustomerView()
        }
    }
}




extension HelpsVC: UITableViewDelegate, UITableViewDataSource{
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  mode?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let  cell = tableView.dequeueReusableCell(withIdentifier: expansionCell.identity(), for: indexPath) as? expansionCell{
            
            if let item = mode?.items[indexPath.row]{
                // 选中cell
                if selectedCellIndexPath.contains(indexPath){
                    item.selected = true
                    cell.mode = item
                    
                }else{
                    item.selected = false
                    cell.mode = item
                }
                
            }
            
            return cell
        }
        
        
        return UITableViewCell()
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.viewBackColor()
        let label = UILabel()
        label.text = "常见问题"
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
        label.font = UIFont.systemFont(ofSize: 16)
        v.addSubview(label)
        _ = label.sd_layout().leftSpaceToView(v,TableCellOffsetX)?.bottomSpaceToView(v,5)?.autoHeightRatio(0)
        
        return v
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let item = mode?.items[indexPath.row] else { return 0}
        // 显示已经选择cell 自适应高度
        if selectedCellIndexPath.contains(indexPath){
            
            item.selected = true
            return tableView.cellHeight(for: indexPath, model: item, keyPath: "mode", cellClass: expansionCell.self, contentViewWidth: ScreenW)
        }else{
            
            item.selected = false
            return tableView.cellHeight(for: indexPath, model: item, keyPath: "mode", cellClass: expansionCell.self, contentViewWidth: ScreenW)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let index = selectedCellIndexPath.index(of: indexPath){
            selectedCellIndexPath.remove(at: index)
        }else{
            selectedCellIndexPath.append(indexPath)
        }
        tableView.reloadData()
        
    }
    
}

extension HelpsVC{
    
    // 异步获取数据
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let items = [HelpItemsModel(JSON: ["title":"问题2","content":"当前的无群多群无多群无多放弃而放弃我"])!, HelpItemsModel(JSON: ["title":"问题1","content":"当前的无群多群无多群无多dqwd 当前为多\n放弃而放弃我"])!, HelpItemsModel(JSON: ["title":"问题3","content":"当前的无群多群无多群无多dqwdq放弃而  \n dqwdq-dadwq 放弃我\n dqwdqwd "])!,
                HelpItemsModel(JSON: ["title":"问题4","content":"当前的无群多群无多群无多dqwdq放弃而  \n dqwdq-dadwq 放弃我\n dqwdqwd "])!, HelpItemsModel(JSON: ["title":"问题当前的群无群多群无多无群","content":"当前的无群多群无多群无多dqwdq放弃而 当前为多群无多当前为多群无  当前为多群无 \n dqwdwq  dqwdwqd dwqdw\n dqwdq-dadwq 放弃我\n dqwdqwd "])!
                ]
            
            // 6 个
            let guide:[HelpGuidModel] = [HelpGuidModel(JSON: ["name":"求职攻略","image":"bell","guideURL":"地址"])!, HelpGuidModel(JSON: ["name":"简历填写","image":"bell","guideURL":"地址"])!,
                HelpGuidModel(JSON: ["name":"账号管理","image":"bell","guideURL":"地址"])!,HelpGuidModel(JSON: ["name":"论坛中心","image":"bell","guideURL":"地址"])!,HelpGuidModel(JSON: ["name":"防骗指南","image":"bell","guideURL":"地址"])!,
                HelpGuidModel(JSON: ["name":"其它功能","image":"bell","guideURL":"地址"])!]
            
            guide.forEach{
                
                self?.shareItems.append(ShareItem.init(name:$0.name!,image:$0.image!))
            }
            
            
            Thread.sleep(forTimeInterval: 1)
            
            self?.mode = HelpAskModel(JSON: [:])
            self?.mode?.items = items
            self?.mode?.guide = guide
            
           
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
        }
        
    }
}

// 指导界面
extension HelpsVC: headerCollectionViewDelegate{
    
    func chooseItem(name: String, row: Int) {
        if let guide = self.mode?.guide[row], let url = guide.guideURL{
            let wb = baseWebViewController()
            wb.mode = "http://www.sohu.com/a/144471615_687630"
            self.navigationController?.pushViewController(wb, animated: true)
        }
    }
    
    
    
}


