//
//  DropValidTimeView.swift
//  internals
//
//  Created by ke.liang on 2018/4/24.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let pickerViewH:CGFloat = 200
fileprivate let menuH:CGFloat = 40


class DropValidTimeView: BaseSingleItemDropView {

    
    private lazy var pickerData = SelectItemUtil.shared.getItems(name: "日期")
    
    //private lazy var pickerData

    private lazy var dateStr:String = ""
    
    private lazy var datePicker:UIDatePicker = {
        //创建日期选择器
        
        let datePicker = UIDatePicker(frame: CGRect.init(x: 0, y: 0, width: ScreenW, height: pickerViewH))
        datePicker.backgroundColor = UIColor.white
        //将日期选择器区域设置为中文，则选择器日期显示为中文
        datePicker.locale = Locale(identifier: "zh_CN")
        datePicker.isHidden  = true
        datePicker.datePickerMode = .date
        
        var dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let minDate = dateFormat.date(from: "2016-1-1")
        datePicker.maximumDate = Date()
        datePicker.minimumDate = minDate
    
        datePicker.date = Date()
        
        return datePicker
    }()
    
    private lazy var cancelBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return btn
    }()
    
    private lazy var confirmBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.blue
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var bottomView:UIView = {
        let v = UIView(frame: CGRect.zero)
        v.backgroundColor = UIColor.white
        return v
        
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 不遮挡 子view
        
        self.clipsToBounds = false
        loadData()
        
      
        self.addSubview(datePicker)
        
     
        
        bottomView.addSubview(cancelBtn)
        bottomView.addSubview(confirmBtn)
        _ = cancelBtn.sd_layout().leftSpaceToView(bottomView,10)?.bottomSpaceToView(bottomView,5)?.widthRatioToView(bottomView,0.45)?.heightRatioToView(bottomView,0.8)
        _ = confirmBtn.sd_layout().rightSpaceToView(bottomView,10)?.bottomEqualToView(cancelBtn)?.widthRatioToView(cancelBtn,1)?.heightRatioToView(cancelBtn,1)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    
    private func showPickerView() {
        self.table.isHidden = true
        // 加入到keywinds，让button成为第一个接受点击事件
        UIApplication.shared.keyWindow?.addSubview(bottomView)

        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.datePicker.isHidden = false
        }, completion: { bool in
            self.bottomView.frame = CGRect.init(x: 0, y: NavH + menuH + pickerViewH, width: ScreenW, height: 40)
        
        })
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //super.tableView(tableView, cellForRowAt: indexPath)
        if indexPath.row == 2 && !dateStr.isEmpty{
            // 不是重复利用的cell
            let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
            cell.textLabel?.text = dateStr
            let imageView = UIImageView.init(image: #imageLiteral(resourceName: "month").withRenderingMode(.alwaysTemplate))
            imageView.clipsToBounds = true
            
            imageView.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
            cell.accessoryView = imageView
            
            return cell
            
        }else{
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 2{
            tableView.deselectRow(at: indexPath, animated: false)
            showPickerView()
            
        }else{
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
        
    }
    
 
    
    override func dropDownViewClosed() {
        super.dropDownViewClosed()
        cancel()
    }
    
    
}





extension DropValidTimeView{
    @objc private func cancel(){
        recover(animation: true)
    }
    
    @objc private func confirm(){
        
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy年MM月dd日"
        dateStr = formatter.string(from: datePicker.date)
        self.table.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .automatic)
        self.passData?(dateStr)
        
 
        recover(animation:false)
        self.hideMenu()
    }
    
   
    
    private func recover(animation: Bool){
        if animation{
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.datePicker.isHidden = true
                
                //self.datePicker.frame =  CGRect.init(x: 0, y: 0, width: ScreenW, height: 0)
                self.bottomView.removeFromSuperview()
                
            })
        }else{
            self.datePicker.isHidden = true
            
            //self.datePicker.frame =  CGRect.init(x: 0, y: 0, width: ScreenW, height: 0)
            self.bottomView.removeFromSuperview()
        }
      
        
        self.table.isHidden = false
        
    }
}


extension DropValidTimeView{
    private func loadData(){
        // 从网络获取数据
        //
        datas =   ["将来","过去","具体时间"]
        
        
    }
}
