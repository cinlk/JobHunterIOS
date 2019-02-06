//
//  MagazineViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/17.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class MagazineViewController: BaseViewController {

    
    private lazy var dataType:newsType = .none
    
    
    private var modes:[MagazineModel] = []
    
    private lazy var table:UITableView = { [unowned self] in
        let tb = UITableView()
        tb.backgroundColor = UIColor.viewBackColor()
        tb.tableFooterView = UIView()
        tb.separatorStyle = .singleLine
        tb.register(MagineTableViewCell.self, forCellReuseIdentifier: MagineTableViewCell.identity())
        tb.dataSource = self
        tb.delegate = self
        return tb
        
    }()
    
    
     
    init(dataType:newsType) {
        super.init(nibName: nil, bundle: nil)
        self.dataType = dataType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        loadData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
 
        
    }
    
    
    
    
    override func setViews() {
        self.view.addSubview(table)
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
        self.hiddenViews.append(table)
        super.setViews()
        
        
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
        self.table.reloadData()
    }
    
    override func reload() {
        super.reload()
        loadData()
    }
    
    
    
}



extension MagazineViewController{
    
    private func loadData(){
        
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            Thread.sleep(forTimeInterval: 2)
            guard let type = self?.dataType else { return }
            switch type{
                case let .toutiao(name, url):
                   // print(name, url)
                    break
                default:
                    break
            }
            
            for _ in 0..<12{
                self?.modes.append(MagazineModel(JSON: ["title":"这是比当前为多群无多群dqwd当前为多群多多群无多群",
                                                        "author":"作家名字","time":Date().timeIntervalSince1970,
                                                        "icon":"ali","link":"https://mbd.baidu.com/newspage/data/landingsuper?context=%7B%22nid%22%3A%22news_16025880631863946564%22%7D&n_type=0&p_from=1"])!)
                
            }
            
            DispatchQueue.main.async(execute: {
                self?.didFinishloadData()
            })
        }
    }
}


extension MagazineViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = table.dequeueReusableCell(withIdentifier: MagineTableViewCell.identity(), for: indexPath) as? MagineTableViewCell{
            cell.mode = modes[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mode = modes[indexPath.row]
        
        return table.cellHeight(for: indexPath, model: mode, keyPath: "mode", cellClass: MagineTableViewCell.self, contentViewWidth: GlobalConfig.ScreenW)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: false)
        let webview = BaseWebViewController()
        webview.mode = modes[indexPath.row].link
        webview.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(webview, animated: true)
        //
    }
    
    
}
