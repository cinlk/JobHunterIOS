//
//  itemPickerView.swift
//  internals
//
//  Created by ke.liang on 2018/2/7.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit


protocol itemPickerDelegate: class {
    
    func quitPickerView(_ picker:UIPickerView)
    func changeItemValue(_ picker:UIPickerView, value:String, position:[Int:Int])
    
}

// 选择器view
class itemPickerView: UIView {
    
    private lazy var cancel:UIButton = { [unowned self] in
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.frame = CGRect.zero
        btn.setTitle("取消", for: .normal)
        btn.setImage(UIImage.init(), for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(quit), for: .touchUpInside)
        return btn
    }()
    
    private lazy var choose:UIButton = { [unowned self] in
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.frame = CGRect.zero
        btn.setTitle("完成", for: .normal)
        btn.setImage(UIImage.init(), for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(done), for: .touchUpInside)
        return btn
    }()
    
    private lazy var pickView:UIPickerView = { [unowned self] in
        let pick = UIPickerView.init()
        pick.showsSelectionIndicator = true
        pick.dataSource = self
        pick.delegate = self
        return pick
    }()
    
    weak var pickerDelegate:itemPickerDelegate?
    
    
    // 数据树结构
    private var root:nodes = nodes.init()
    private var name:String = ""
    private var count = 0
    // 记录当前选择的component 和 row
    private var componentMatrix:[Int:Int] = [:]
    // 存储每层树节点最左边孩子节点集合
    private var nodeComponents:[Int:[component]] = [:]
    
    private var tmp = [[component]]()
    
    var mode:(name:String ,root:nodes)?{
        didSet{
            self.name = mode!.name
            self.root = mode!.root
            
            componentMatrix.removeAll()
            nodeComponents.removeAll()
            self.root.getfirtChildrenNodes(name: name, res: &tmp)
            for (index,items) in tmp.enumerated(){
                nodeComponents[index] = items
                componentMatrix[index] = 0
            }
            
            count = tmp.count
            tmp.removeAll()
            
            self.pickView.reloadAllComponents()
        
        }
    }
    
     override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(pickView)
        self.addSubview(cancel)
        self.addSubview(choose)
        
        _ = cancel.sd_layout().leftSpaceToView(self,10)?.topSpaceToView(self,10)?.widthIs(50)?.heightIs(30)
        _ = choose.sd_layout().rightSpaceToView(self,10)?.topSpaceToView(self,10)?.heightRatioToView(cancel,1)?.widthRatioToView(cancel,1)
        _ = pickView.sd_layout().leftEqualToView(self)?.rightEqualToView(self)?.bottomEqualToView(self)?.topSpaceToView(choose,5)
        
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension itemPickerView{
    open func setPosition(position:[Int:Int]?){
        
        
        // 初始位置
        guard let p  = position else {
            self.pickView.selectRow(0, inComponent: 0, animated: false)
            return
        }
        
        // 根据位置刷新孩子节点数据，然后滚动指定位置
        componentMatrix = p
        for (c, row) in p {
            if row != 0 {
                let selectedNode = nodeComponents[c]![row]
                // 刷新子components
                let nextComponent = c + 1
                if nextComponent < nodeComponents.count{
                    nodeComponents[nextComponent] = self.root.getNodeByName(name: selectedNode.key)?.item
                    self.pickView.reloadComponent(nextComponent)
                }
            }
            
            self.pickView.selectRow(row, inComponent: c, animated: false)
        }
        
        
    }
}

extension itemPickerView: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return self.nodeComponents.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let col =  self.nodeComponents[component] else {
            return 0
        }
        
        return col.count
    
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.nodeComponents[component]![row].key
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return ScreenW / CGFloat(self.nodeComponents.count)  - 50
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if componentMatrix[component] == row {
            return
        }
        
        let selectedNode = nodeComponents[component]![row]
        /// 记录选择的(component,row)
        componentMatrix[component] = row
        // 根据前component里的node 刷孩子节点，放到下一层的component
        let nextComponent = component + 1
        if nextComponent < nodeComponents.count{
            nodeComponents[nextComponent] = self.root.getNodeByName(name: selectedNode.key)?.item
            self.pickView.reloadComponent(nextComponent)
        }
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        
        let  label = UILabel.init()
        label.text = self.nodeComponents[component]![row].key
        label.textColor = UIColor.blue
        label.textAlignment = .center
        return label
       
    }
    
}

extension itemPickerView{
    
    @objc private func quit(){
        
        pickerDelegate?.quitPickerView(self.pickView)
        
    }
    
    @objc private func done(){
        var v:String?
        
        switch name {
        case "生日":
            v = self.nodeComponents[0]![componentMatrix[0]!].key + "-" +
                    self.nodeComponents[count-1]![componentMatrix[count-1]!].key
            
        default:
            v = self.nodeComponents[count - 1]?[componentMatrix[count - 1]!].key
        }
        
        if let value = v{
            pickerDelegate?.changeItemValue(self.pickView, value: value, position: componentMatrix )
        }
        
        
        
    }
}
