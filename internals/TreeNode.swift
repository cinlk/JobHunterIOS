

import Foundation




fileprivate let condition_business =  ["不限":[],"IT/互联网":["互联网/电子商务","网络游戏","计算机软件","IT服务/系统集成"],"电子/通信/硬件":["电子技术/半导体/集成电路","通信","计算机硬件"],"金融":["银行","保险","会计/审计","基金/证券/投资"],"汽车/机械/制造":["汽车/模特","印刷/包装/造纸","加工制造"]]


fileprivate let condition_jobs:[String:Any] = ["销售/客服":["销售业务":["销售代表","客户代表","项目执行","代理销售","保险销售"],"销售管理":["客户经理/主管","大客户销售经理","招商总监","团购经理/主管"],"销售行政":["销售行政专员/助理","商务专员/助理","业务分析师/主管"],"客服":["VIP专员","网络客服","客服总监"]],"技术":["前端开发":["web开发","JavaScript","HTML5","Flash"],"后端开发":["Java","Python","PHP",".NET","C#","C/C++","Golang"]],"产品/设计/运营":["产品":["产品助理","网页产品"],"设计":["网页设计","UI设计","美术设计"],"运营":["数据运营","产品运营"]],"项目管理/质量管理":["项目管理/项目协调","质量管理/安全防护"]]


fileprivate let condition_internSalary =  ["不限","80/天","100/天","150/天","200/天","250/天"]
fileprivate let condition_salary = ["不限","2000元/月以下","2000-5000元/月","5000-10000元/月","10000-15000元/月","15000元/月以上"]
fileprivate let condition_internDay = ["2天/周","3天/周","4天/周","5天/周"]
fileprivate let condition_internMonth = ["1个月","2个月","3个月","4个月","5个月","半年","半年以上"]

// 日期



enum nodeType {
    case root
    case children
    case leaf
    
}

class component:CustomDebugStringConvertible{
    
    // 孩子节点
    var item:[component]
    // key 要唯一
    var key:String
    // 祖先节点
    var parent:component?
    var type:nodeType
    //记录自己的位置
    var point:(level:Int,row:Int) = (0,0)
    // 被标记选中
    var selected:Bool = false{
        didSet{
            callParent(status: selected)
        }
    }
    // 维护被选中孩子节点数
    var ChildSelectedCounts:Int = 0
    
    // 孩子节点选中状态变化通知父节点更新选中状态
    private func callParent(status:Bool){
        if let p = parent{
            if status{
                p.ChildSelectedCounts += 1
            }else{
                p.ChildSelectedCounts -= 1
            }
            if p.ChildSelectedCounts <= 0 {
                p.ChildSelectedCounts = 0
                p.selected = false
            }else{
                // 父节点已经被选中，则不设置在次选中，才保证祖先节点正确的ChildSelectedCounts
                if p.selected == false{
                    p.selected = true
                }
            }
            //print(p.selected,p.ChildSelectedCounts,p.key)
            
        }
    }
    // 构造函数
    init(type:nodeType ,key:String, parent:component?, item:[component],point:(Int,Int) = (0,0)) {
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
    }
    
    var debugDescription: String{
        let res = "nodeName: " + key +  "  posit: \(self.point)  "
        return res
    }
    
}

class nodes{
    
    // 多个树的集合，也可以存单个root（一个树）
    private var root:[component] = []
    
    
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
        
        if node.parent?.key == root.key{
            root.item.append(node)
            return
        }
        for var item in root.item{
            setNode(node: node, root: &item)
        }
    }
    
    // 清楚选中状态
    func clearSelectedStatus(node:component){
        if node.selected{
            node.selected = false
            for item in node.item{
                clearSelectedStatus(node: item)
            }
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
    
    
    
    // address 从plist获取的字典数据是Any类型，需要手动一层一层解析数据类型。
    private func address(){
        let name:String = "城市"
        let tree = nodes.init()
        let path = Bundle.main.path(forResource: "address", ofType: "plist")
        let address =  NSDictionary(contentsOfFile: path!) as! Dictionary<String, Any>
        // build tree
        let rootNode = component.init(type: .root, key: name, parent: nil, item: [], point: (0,0))
        tree.buildData(node: rootNode)
        let province = address[name] as! NSArray
        for (index,item) in province.enumerated(){
            let item = item as! Dictionary<String,[String]>
            for (key,varry) in  item{
                let provinceNode =  component.init(type: .children, key: key, parent: rootNode, item: [], point: (rootNode.point.level + 1, index))
                tree.buildData(node: provinceNode)
                for (row,cityName) in varry.enumerated(){
                    let cityNode = component.init(type: .children, key: cityName, parent: provinceNode, item: [], point: (provinceNode.point.level + 1, row))
                    tree.buildData(node: cityNode)
                }
            }
           
            
        }
    
        self.itemNode[name] = tree
    }
    
    // 学历
    private func degress(){
        let name:String = "学历"
        let path = Bundle.main.path(forResource: "degrees", ofType: "plist")
        let arr = NSArray.init(contentsOfFile: path!) as! Array<String>
        let tree = nodes.init()
        let root = component.init(type: .root, key: name, parent: nil, item: [])
        tree.buildData(node: root)
        for (index,item) in arr.enumerated(){
            let node = component.init(type: .children, key: item, parent: root, item: [],
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
        let root = component.init(type: .root, key: "生日", parent: nil, item: [])
        
        tree.buildData(node: root)
        
        for  (index,item) in (date["生日"] as! NSArray).enumerated(){
            
            let items =  (item as! Dictionary<String,[String]>).sorted(by: { (t1, t2) -> Bool in
                return t1.key < t2.key
            })
            
            for (year,months) in items{
                let yearNode = component.init(type: .children, key: year, parent: root, item: [], point:(root.point.level + 1, index))
                tree.buildData(node: yearNode)
                
                for  (row,month) in months.enumerated(){
                    let monthNode = component.init(type: .children, key: month, parent: yearNode, item: [], point: (yearNode.point.level + 1, row))
                    tree.buildData(node: monthNode)
                }
            }
        }
        
        
        self.itemNode["生日"] = tree
        
        
    }
    
    
    private func creatTreeBy(name:String, target:Any){
        
        let tree = nodes.init()
        let rootNode = component.init(type: .root, key: name, parent: nil, item: [], point:(0,0))
        
        tree.buildData(node: rootNode)
        
        recurese(obj: target, parent: rootNode, tree: tree, level:1)
        self.itemNode[name] = tree
        
    }
    // 递归构建tree
    // 子节点必须为string数组
    private func recurese(obj:Any, parent:component, tree:nodes, level:Int){
        var index = 0
        if let res =  obj as? Dictionary<String,[String]>{
           
            for (key, values) in res{
                let node = component.init(type: .children, key: key, parent: parent, item: [], point:(level,index))
                tree.buildData(node: node)
                recurese(obj: values, parent: node, tree: tree, level: level+1)
                index += 1
            }
            return
        }
        if let res = obj as? [String]{
            for item in res{
                let node = component.init(type: .children, key: item, parent: parent, item: [], point:(level,index))
                tree.buildData(node: node)
                index += 1
            }
            return
        }
        
        if let res = obj as? Dictionary<String, Any>{
            for (key,value) in res{
                let node = component.init(type: .children, key: key, parent: parent, item: [], point:(level,index))
                tree.buildData(node: node)
                recurese(obj: value, parent: node, tree: tree, level: level+1)
                index += 1
            }
            
            return
        }
        
        
        
        
    }
    
    
    // 初始化数据
    private func initialDatas(){
        // bundle
        address()
        degress()
        birthDay()
        
        
        creatTreeBy(name: ResumeInfoType.gender.describe, target: ["男","女"])
        creatTreeBy(name: ResumeInfoType.skill.describe, target: ["专业技能","语言水平","兴趣爱好","其他"])
        creatTreeBy(name: "反馈", target: ["产品建议","系统问题","其他"])
        creatTreeBy(name: ResumeInfoType.workType.describe, target: ["全职","兼职","实习"])
        
        creatTreeBy(name: ResumeInfoType.pScale.describe, target: ["1-20人","20-50人","50人以上"])
        creatTreeBy(name: ResumeInfoType.rank.describe, target: ["前5%", "前10%","前30%","前50%", "其它"])
        creatTreeBy(name: "职位类型", target: ["校招", "实习"])
        creatTreeBy(name: "职位类别", target:condition_jobs)
        creatTreeBy(name: "薪资范围", target: condition_salary)
        creatTreeBy(name: "从事行业", target: condition_business)
        creatTreeBy(name: "实习天数", target: condition_internDay)
        creatTreeBy(name: "实习时间", target: condition_internMonth)
        creatTreeBy(name: "实习薪水", target: condition_internSalary)
        // test Picker 日期
        
        
        var res = Dictionary<String,Dictionary<String,[String]>>()
    
        
        let year = ["2017","2018","2019"]
        var month:[String] = []
        var days:[String] = []
        for i in 0..<12{
            month.append("\(i+1)月")
        }
        for i in 0..<31{
            days.append("\(i+1)日")
        }
        
        for y in year{
            var dic:[String:[String]] = [:]
            
            for m in month{
                dic[m] = days
                
            }
            res[y] = dic
            
        }
        
         print(res)
         creatTreeBy(name: "日期", target: res)
         self.itemNode["日期"]?.printNodes()
        
       
        
        
    }
    // 清理selected 状态
    open func clearByName(name:String){
        if let root = itemNode[name]{
            // root 节点不会被选中的
            if let node = root.getNodeByName(name: name){
                // 从孩子节点开始
                node.item.forEach{
                    root.clearSelectedStatus(node: $0)
                }
            }
        }
    }
    
    open func getItems(name:String)->nodes?{
        
        return itemNode[name]
    }
}


