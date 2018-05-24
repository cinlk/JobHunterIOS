//
//  HelpsVC.swift
//  internals
//
//  Created by ke.liang on 2018/2/22.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let headerH:CGFloat = 160
fileprivate let itemCGSize:CGSize = CGSize.init(width: ScreenW / 2 - 40 , height: headerH / 2 - 20)
fileprivate let sectionH:CGFloat = 25


class HelpsVC: BaseViewController {

    
    
    private lazy var tableView: UITableView = { [unowned self] in
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
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
        self.navigationItem.title = "帮助"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    
    override func setViews() {
        self.view.addSubview(tableView)
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
            // 不显示遮挡部分
            cell.layer.masksToBounds = true
            
            return cell
        }
        
        
        return UITableViewCell()
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "常见问题"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionH
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
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

extension HelpsVC{
    
    // 异步获取数据
    private func loadData(){
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let items = [HelpItemsModel(JSON: ["title":"问题2","content":"当前的无群多群无多群无多放弃而放弃我"])!, HelpItemsModel(JSON: ["title":"问题1","content":"当前的无群多群无多群无多dqwd 当前为多\n放弃而放弃我"])!, HelpItemsModel(JSON: ["title":"问题3","content":"当前的无群多群无多群无多dqwdq放弃而  \n dqwdq-dadwq 放弃我\n dqwdqwd "])!,
                HelpItemsModel(JSON: ["title":"问题4","content":"当前的无群多群无多群无多dqwdq放弃而  \n dqwdq-dadwq 放弃我\n dqwdqwd "])!
                ]
            
            let guide:[HelpGuidModel] = [HelpGuidModel(JSON: ["name":"指导1","image":"bell"])!, HelpGuidModel(JSON: ["name":"指导2","image":"bell"])!,
                HelpGuidModel(JSON: ["name":"指导3","image":"bell"])!,HelpGuidModel(JSON: ["name":"指导4","image":"bell"])!]
            
            guide.forEach{
                
                self?.shareItems.append(ShareItem.init(name:$0.name!,image:$0.image!))
            }
            
            
            Thread.sleep(forTimeInterval: 3)
            
            self?.mode = HelpAskModel(JSON: [:])
            self?.mode?.items = items
            self?.mode?.guide = guide
            
           
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
        }
        
    }
}

// 选中头部图 进入指导
extension HelpsVC: headerCollectionViewDelegate{
    
    func chooseItem(name: String) {
//        if let item = self.mode?.guide[index]{
//            print(item)
//            self.navigationController?.pushViewController(HelpGuideViewController(), animated: true)
//        }
    }
    
    
    
}


