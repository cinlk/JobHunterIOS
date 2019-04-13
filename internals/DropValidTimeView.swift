//
//  DropValidTimeView.swift
//  internals
//
//  Created by ke.liang on 2018/4/24.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

fileprivate let pickerViewH:CGFloat = 240
fileprivate let menuH:CGFloat = 40
fileprivate let titles:[String] = ["将来","过去","具体时间"]


fileprivate class datePickerView:UIView {
    
    
    private weak var pview:DropValidTimeView?
    
    internal var date:Date{
        get{
            return self.picker.date
        }
    }
    
    private lazy var picker:UIDatePicker = {
        let picker = UIDatePicker.init(frame: CGRect.zero)
        picker.backgroundColor = UIColor.white
        picker.locale = GlobalConfig.locale
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.minimumDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        picker.maximumDate = Calendar.current.date(byAdding: Calendar.Component.year, value: 2, to: Date())
        picker.date = Date()
        return picker
    }()
    
    private lazy var cancelBtn:UIButton = { [unowned self] in
        let btn = UIButton()
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.layer.borderWidth = 1
        btn.addTarget(self.pview!, action: #selector(self.pview!.cancel), for: .touchUpInside)
        return btn
    }()
    
    private lazy var confirmBtn:UIButton = {  [unowned self] in
        let btn = UIButton()
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.blue
        btn.layer.borderWidth = 1
        btn.addTarget(self.pview!, action: #selector(self.pview!.confirm), for: .touchUpInside)
        return btn
    }()
    
    
    convenience init(frame: CGRect, v:DropValidTimeView){
        self.init(frame: frame)
        self.pview = v
        self.backgroundColor = UIColor.white
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
       
        let views:[UIView] = [picker, cancelBtn, confirmBtn]
        self.sd_addSubviews(views)
        _ = cancelBtn.sd_layout()?.leftSpaceToView(self,10)?.bottomSpaceToView(self,5)?.widthRatioToView(self, 0.45)?.heightIs(40)
        _ = confirmBtn.sd_layout()?.rightSpaceToView(self, 10)?.bottomEqualToView(cancelBtn)?.widthRatioToView(cancelBtn,1)?.heightRatioToView(cancelBtn,1)
        _ = self.picker.sd_layout()?.leftEqualToView(self)?.rightEqualToView(self)?.topEqualToView(self)?.bottomSpaceToView(self.cancelBtn,2.5)
        
         super.layoutSubviews()
    }
    
    
}


class DropValidTimeView: BaseSingleItemDropView {

    
    private lazy var dateStr:String = ""
    
    private lazy var datePicker:datePickerView = {  [unowned self] in
        //创建日期选择器
        let datePicker = datePickerView.init(frame: CGRect.init(x: 0, y: GlobalConfig.NavH + menuH, width: GlobalConfig.ScreenW, height: pickerViewH), v:self )
        datePicker.isHidden = true
        return datePicker
    }()
    
 
    
    
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 不遮挡 子view
        self.clipsToBounds = false
        datas =  titles
        
    }
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }
    
    
    private func showPickerView() {
        self.table.isHidden = true
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.datePicker.isHidden = false
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
            //cell.textLabel?.textColor = UIColor.bl
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
    
    override func dropDownViewOpened() {
        super.dropDownViewOpened()
      
        // 加入最外层，才能触发button 点击
        UIApplication.shared.keyWindow?.addSubview(datePicker)
    }
 
    
    override func dropDownViewClosed() {
        
        super.dropDownViewClosed()
        self.datePicker.removeFromSuperview()
        cancel()
    }
    
   
}







extension DropValidTimeView{
    
    @objc internal func cancel(){
       
        
        self.datePicker.isHidden = true
        self.table.isHidden = false
    }
    
    @objc internal func confirm(){
        
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy年MM月dd日"
        dateStr = formatter.string(from: datePicker.date)
        self.table.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .automatic)
        self.passData?(dateStr)
        self.cancel()
        self.hideMenu()
    }
    
   
    class func myHeigh() -> CGFloat{
        return CGFloat(titles.count * 45)
    }
 
}



