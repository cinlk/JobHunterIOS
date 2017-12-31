//
//  searchResultController.swift
//  internals
//
//  Created by ke.liang on 2017/12/16.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import MJRefresh
import SVProgressHUD

class searchResultController: UIViewController,UIScrollViewDelegate {

    lazy var table:UITableView = {
       let tb = UITableView.init()
        tb.register(jobdetailCell.self, forCellReuseIdentifier: jobdetailCell.identity())
        tb.tableFooterView = UIView.init()
        return tb
    }()
    
    
    private let disposebag = DisposeBag.init()
    
    var vm:searchViewModel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.table)
        self.searchModeView()
        
    }

    override func viewWillLayoutSubviews() {
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
    }
  


}



extension searchResultController{
    
    func searchModeView(){
        
        self.vm = searchViewModel.init()
        
        table.rx.setDelegate(self).disposed(by: disposebag)
        let datasource =
            RxTableViewSectionedReloadDataSource<searchJobSection>.init(configureCell: {
                (_,tb,indexpath,element) in
                let cell = tb.dequeueReusableCell(withIdentifier: jobdetailCell.identity(), for: indexpath) as! jobdetailCell
                cell.createCells(items: element.toJSON())
                return cell
            })
        
        //        datasource.titleForFooterInSection = {
        //            dataSource, sectionindex in
        //            return datasource[sectionindex].model
        //        }
        
        vm.section?.asDriver().drive(table.rx.items(dataSource: datasource)).disposed(by: disposebag)
        
        
        
        table.mj_footer = MJRefreshAutoNormalFooter.init {
            print("上拉")
            self.vm.isRefresh.onNext(true)
            
        }
        

        vm.refreshStatus.asDriver().drive(onNext: { [unowned self]  (state) in
            switch state{
            case .endFooterRefresh:
                self.table.mj_footer.endRefreshing()
                
            case .NoMoreData:
                self.table.mj_footer.endRefreshingWithNoMoreData()
                
            default:
                
                print("end ")
            }
            SVProgressHUD.dismiss()
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposebag)
        
    }
    
}

