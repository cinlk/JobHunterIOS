//
//  SearchTypeMenuView.swift
//  internals
//
//  Created by ke.liang on 2018/4/28.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol SearchMenuDelegate: class {
    func selectedItem(item: searchItem)
 }


fileprivate let frameWidth:CGFloat = 100

class SearchTypeMenuView: UIView {
    
    
    
    internal var datas:[searchItem] = [] {
        didSet{
            self.table.reloadData()
            if !datas.contains(.online){
                 self.frame.size = CGSize.init(width: frameWidth, height: CGFloat(datas.count) * SearchTypeMenuView.cellHeight())
            }
            //self.frame.size = CGSize.init(width: frameWidth, height: CGFloat(datas.count) * SearchTypeMenuView.cellHeight())
        }
    }
    
    //private lazy var dispose:DisposeBag = DisposeBag.init()
    
    private var arrowWidth:CGFloat = 15
    private var arrowHeight:CGFloat = 10
    internal var arrowLeftMargin:CGFloat = 15
    
    weak var delegate:SearchMenuDelegate?
    
    // 三角箭头
    private lazy var arrow:UIView = {  [unowned self] in
        //let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: arrowHeight))
        let view = UIView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        let layer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint.init(x: arrowLeftMargin + (arrowWidth)/2, y: 0))
        path.addLine(to: CGPoint.init(x: arrowLeftMargin, y: arrowHeight))
        path.addLine(to: CGPoint.init(x: arrowLeftMargin + arrowWidth, y: arrowHeight))
        layer.path = path.cgPath
        layer.fillColor = UIColor.white.cgColor
        view.layer.masksToBounds = true
        view.layer.addSublayer(layer)
        return view
    }()
    
    // 内容
    internal lazy var table:UITableView = {  [unowned self] in
        //let table = UITableView(frame: CGRect.init(x: 0, y: arrowHeight , width: self.frame.width - 30, height: self.frame.height - arrowHeight))
        let table = UITableView.init(frame: CGRect.zero)
        table.tableHeaderView = UIView()
        table.backgroundColor = UIColor.white
        table.dataSource = self
        table.delegate = self
        table.showsVerticalScrollIndicator = false
        table.isScrollEnabled = false
        table.layer.cornerRadius = 10
        table.layer.masksToBounds = true
        table.bounces = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table

    }()

    // 蒙层view
    private lazy var backgroundBtn:UIButton = {  [unowned self] in
        
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: GlobalConfig.ScreenW, height: GlobalConfig.ScreenH))
        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        btn.backgroundColor = UIColor.lightGray
        btn.alpha = 0.5
        return btn
    }()
    
    
     init(frame: CGRect, arrowLeftMargin:CGFloat = 15) {
        super.init(frame: frame)
        //self.frame.size = CGSize.init(width: frameWidth, height: 0)
        self.arrowLeftMargin = arrowLeftMargin
       
        _ = NotificationCenter.default.rx.notification(NotificationName.searchType).takeUntil(self.rx.deallocated).subscribe(onNext: { [weak self] (notify) in
            if let searchType = notify.userInfo?["searchType"] as? searchItem{
                switch searchType{
                    case .company, .intern, .meeting, .graduate, .onlineApply:
                        self?.datas = [.company, .intern, .meeting, .graduate, .onlineApply]
                default:
                    break
                }
            }
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        self.addSubview(table)
        self.addSubview(arrow)
        _ = self.arrow.sd_layout()?.leftEqualToView(self)?.topEqualToView(self)?.widthRatioToView(self,1)?.heightIs(arrowHeight)
        _ = self.table.sd_layout()?.leftEqualToView(self)?.topSpaceToView(self.arrow,0)?.rightSpaceToView(self,30)?.bottomSpaceToView(self, 0)
        
        super.layoutSubviews()
        
        
    }

}


extension SearchTypeMenuView{
    
    open func show(){
        
        UIApplication.shared.keyWindow?.addSubview(backgroundBtn)
        UIApplication.shared.keyWindow?.addSubview(self)
        
        
    }
    
    
    
    @objc open func dismiss(){
        backgroundBtn.removeFromSuperview()
        self.removeFromSuperview()
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
}




extension SearchTypeMenuView{
    
    class func cellHeight()->CGFloat{
        return 30
    }
}

extension SearchTypeMenuView: UITableViewDataSource, UITableViewDelegate{

    func numberOfRows(inSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = datas[indexPath.row].describe
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        if datas.contains(.online){
             cell.textLabel?.textAlignment = .left
        }else{
             cell.textLabel?.textAlignment = .center
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    // 最后一个cell 点击透传
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.selectedItem(item: datas[indexPath.row])
        self.dismiss()
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchTypeMenuView.cellHeight()
    }

}




