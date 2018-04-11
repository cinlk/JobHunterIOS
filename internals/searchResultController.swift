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



class searchResultController: BaseViewController,UIScrollViewDelegate {

    lazy var table:UITableView = {
       let tb = UITableView.init()
        tb.register(jobdetailCell.self, forCellReuseIdentifier: jobdetailCell.identity())
        tb.tableFooterView = UIView.init()
        return tb
    }()
    
    
    private let disposebag = DisposeBag.init()
    
    var vm:searchViewModel!
    
    
    // MARK 保留搜索条件
    var currentKey = "搜索"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViews()
        
    }

    
    override func viewWillLayoutSubviews() {
        _ = table.sd_layout().leftEqualToView(self.view)?.rightEqualToView(self.view)?.topEqualToView(self.view)?.bottomEqualToView(self.view)
    }
  
    override func setViews() {
        self.view.addSubview(self.table)
        self.searchModeView()
        self.handleViews.append(table)
        super.setViews()
    }
    
    override func showError() {
        super.showError()
    }
    
    override func reload() {
        super.reload()
        //
        self.vm.loadData.onNext(currentKey)
    }
    
    override func didFinishloadData() {
        super.didFinishloadData()
    }
    
    
    // 刷新数据
    private func refresh(){
        super.setViews()
        self.vm.loadData.onNext(currentKey)
    }


    
}


extension searchResultController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return jobdetailCell.cellHeight()
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
                cell.mode = element
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
        

        
        vm.refreshStatus.asDriver().drive(onNext: { [weak self]  (state) in
            switch state{
            case .endFooterRefresh:
                self?.table.mj_footer.endRefreshing()
                
            case .NoMoreData:
                self?.table.mj_footer.endRefreshingWithNoMoreData()
            case .end:
                self?.didFinishloadData()
                
            case .error:
                self?.showError()
                
            default:
                
                print("end ")
            }
            //SVProgressHUD.dismiss()
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposebag)
        
    }
    
}


extension searchResultController:baseSearchViewControllerDelegate{
    func startSearch(word: String) {
        // MARK test
        self.currentKey = word
        self.refresh()
    }
}
