

import Foundation


enum nodeType {
    case root
    case children
    case leaf
    
}

class component:CustomDebugStringConvertible{
    
    // 孩子节点
    var item:[component]
    var key:String
    var parent:String
    var type:nodeType
    //记录自己的位置
    var point:(level:Int,row:Int) = (0,0)
    
    init(type:nodeType ,key:String, parent:String, item:[component],point:(Int,Int) = (0,0)) {
        self.key = key
        self.item = item
        self.parent = parent
        self.type = type
        self.point = point
        
    }
    
    // 叶子节点
    init() {
        self.item = []
        self.key = ""
        self.type = .leaf
        self.parent = ""
    }
    
    var debugDescription: String{
        let res = "nodeName: " + key +  "  posit: \(self.point)  "
        return res
    }
    
}

class nodes{
    
    // 多个树的集合，也可以存单个root（一个树）
    var root:[component] = []
    
    init() {}
    
    open func printNodes(){
        if self.root.isEmpty{
            return
        }
        for i in self.root{
            printAll(item: i)
        }
        
    }
    
    private func printAll(item:component){
        
        if item.key == ""{
            return
        }
        var s = ""
        for _ in 0..<item.point.level{
            s += "-"
        }
        print(s + " \(item)")
        for ec in item.item{
            printAll(item: ec)
            
        }
    }
    
    
    
    open func deleteNode(name:String){
        for (index,item) in self.root.enumerated(){
            if item.key == name{
                self.root.remove(at: index)
                return
            }else{
                self.deleteSubNode(name: name, node: item)
            }
        }
        
    }
    private func deleteSubNode(name:String,node:component){
        for (index,item) in node.item.enumerated(){
            if item.key == name{
                node.item.remove(at: index)
            }else{
                self.deleteSubNode(name: name, node: item)
            }
        }
        
    }
    open func getNodeByName(name:String)->component?{
        
        for i in self.root{
            if i.key == name{
                return i
            }else{
                
                if let res = self.findSubnodes(name: name, node: i) {
                    return res
                }
            }
            
        }
        return nil
        
    }
    
    
    private func findSubnodes(name:String,node:component)->component?{
        guard !node.item.isEmpty else {
            return nil
        }
        for i in node.item{
            if i.key == name{
                return i
            }else{
                if let res = self.findSubnodes(name:name, node: i){
                    return res
                }
            }
        }
        return nil
    }

    // 多叉平衡树， 叶子节点都在最底层
    open func treeHeight()->Int{
        guard !self.root.isEmpty else {
            return 0
        }
        // 返回某个分支的高度
        return height(node: self.root[0])
        
    }
    
    private func height(node:component)->Int{
        guard !node.item.isEmpty else {
            return 0
        }
        return 1 + height(node:node.item[0])
    }
    
    
    open func getfirtChildrenNodes(name:String, res: inout [[component]]){
        guard !self.root.isEmpty else {
            return
        }
        
        for item in self.root{
            if item.key == name  && !item.item.isEmpty{
               res.append(item.item)
               getChildrenNodes(node: item.item[0], res: &res)
            }
        }
    }
    
    private func getChildrenNodes(node:component, res: inout [[component]]){
        guard   !node.item.isEmpty else {
            return
        }
        res.append(node.item)
        getChildrenNodes(node: node.item[0], res: &res)
    }
    
    
    
    open func buildData(node:component){
        if node.type == .root{
            self.root.append(node)
        }
            
        else if !self.root.isEmpty{
            for var i in self.root{
                
                self.setNode(node: node, root: &i)
            }
            
        }else{
            print("没有改node")
        }
    }
    
    private func setNode(node:component, root: inout component){
        
        if node.parent == root.key{
            root.item.append(node)
            return
        }
        for var item in root.item{
            setNode(node: node, root: &item)
        }
    }
    
}

//  single class 存储数据
class SelectItemUtil {
    
    
    static let shared:SelectItemUtil = SelectItemUtil.init()
    private init(){
        initialDatas()
        
        
    }
    private var itemNode:[String:nodes] = [:]
    
    
    
    //gender  名字和struct 和plist 是一致的
    private func gender(name:String = "性别"){
        
        let tree = nodes.init()
        let rootNode = component.init(type: .root, key: name, parent: "", item: [], point: (0,0))
        tree.buildData(node: rootNode)
        for (index, item) in ["男","女"].enumerated(){
            let node = component.init(type: .children, key: item, parent: rootNode.key, item: [], point: (rootNode.point.level + 1, index))
            tree.buildData(node: node)
        }
        
        self.itemNode[name] = tree
        
    }
    // 技能类型
    private func skills(name:String = "技能"){
        
        let tree = nodes.init()
        let rootNode = component.init(type: .root, key: name, parent: "", item: [], point: (0,0))
        tree.buildData(node: rootNode)
        for (index, item) in ["职业技能","语言能力","其他"].enumerated(){
            let node = component.init(type: .children, key: item, parent: rootNode.key, item: [], point: (rootNode.point.level + 1, index))
            tree.buildData(node: node)
        }
        
        self.itemNode[name] = tree
    }
    
    // address 从plist获取的字典数据是Any类型，需要手动一层一层解析数据类型。
    private func address(name:String = "城市"){
        let tree = nodes.init()
        let path = Bundle.main.path(forResource: "address", ofType: "plist")
        let address =  NSDictionary(contentsOfFile: path!) as! Dictionary<String, Any>
        // build tree
        let rootNode = component.init(type: .root, key: name, parent: "", item: [], point: (0,0))
        tree.buildData(node: rootNode)
        let province = address[name] as! NSArray
        for (index,item) in province.enumerated(){
            let item = item as! Dictionary<String,[String]>
            for (key,varry) in  item{
                let provinceNode =  component.init(type: .children, key: key, parent: rootNode.key, item: [], point: (rootNode.point.level + 1, index))
                tree.buildData(node: provinceNode)
                for (row,cityName) in varry.enumerated(){
                    let cityNode = component.init(type: .children, key: cityName, parent: provinceNode.key, item: [], point: (provinceNode.point.level + 1, row))
                    tree.buildData(node: cityNode)
                }
            }
           
            
        }
    
        self.itemNode[name] = tree
    }
    
    // 学历
    private func degress(name:String = "学位"){
        let path = Bundle.main.path(forResource: "degrees", ofType: "plist")
        let arr = NSArray.init(contentsOfFile: path!) as! Array<String>
        let tree = nodes.init()
        let root = component.init(type: .root, key: name, parent: "", item: [])
        tree.buildData(node: root)
        for (index,item) in arr.enumerated(){
            let node = component.init(type: .children, key: item, parent: root.key, item: [],
                                      point:(root.point.level + 1, index))
            tree.buildData(node: node)
        }
        
        self.itemNode[name] = tree
    
    }
    
    
    // 生日 年——月
    private func birthDay(){
        let path = Bundle.main.path(forResource: "birthDate", ofType: "plist")
        let date = NSDictionary.init(contentsOfFile: path!) as!  Dictionary<String,Any>
        let tree = nodes.init()
        let root = component.init(type: .root, key: "生日", parent: "", item: [])
        
        tree.buildData(node: root)
        
        for  (index,item) in (date["生日"] as! NSArray).enumerated(){
            
            let items =  (item as! Dictionary<String,[String]>).sorted(by: { (t1, t2) -> Bool in
                return t1.key < t2.key
            })
            
            for (year,months) in items{
                let yearNode = component.init(type: .children, key: year, parent: root.key, item: [], point:(root.point.level + 1, index))
                tree.buildData(node: yearNode)
                
                for  (row,month) in months.enumerated(){
                    let monthNode = component.init(type: .children, key: month, parent: year, item: [], point: (yearNode.point.level + 1, row))
                    tree.buildData(node: monthNode)
                }
            }
        }
        
        
        self.itemNode["生日"] = tree
        
        
    }
    // 专业
    private func department(){
        
    }
    
    
    
    
    
    private func initialDatas(){
        //
        address()
        gender()
        degress()
        birthDay()
        skills()
        
        
    }
    
    open func getItems(name:String)->nodes?{
        
        return itemNode[name]
    }
}


