//
//  cdetails.swift
//  internals
//
//  Created by ke.liang on 2017/9/7.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class cdetails: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource{
    
    
    
    var labelHeight = 30
    var labelWidth = 80
    var threshold:CGFloat = -80
    var marginTop:CGFloat = 0
    
    
    // tag 字数不能太长(大于frame.width)不让换行，页面大小不够显示
    let tags = ["tag1","tag2","tag3dawdwadaw","tag4","tag5","tag6","awdwa","dswdadwadawdawfwefwefwefew","dawf","fefwefwefwefwefwefwfwf","dwad","yrtyjty","吊袜带挖多哇"]
    
    //table2 data
    var joblists:[[String:String]]  = [["jobname":"KPI 设计","locate":"北京","days":"4天/周","createTime":"09-12","salary":"250-300/天","times":"4天/周","time":"5个月","hired":"可转正","scholar":"本科"],
        ["jobname":"IOS 开发","locate":"北京","createTime":"10-12","salary":"200-300/天","times":"4天/周","time":"5个月","hired":"可转正","scholar":"本科"],
        ["jobname":"日语测试","locate":"上海","createTime":"09-01","salary":"300-350/天","times":"4天/周","time":"5个月","hired":"可转正","scholar":"本科"],
        ["jobname":"容器部署","locate":"上海","createTime":"09-01","salary":"300-350/天","times":"4天/周","time":"5个月","hired":"可转正","scholar":"本科"],
        ["jobname":"软件培训","locate":"上海","createTime":"09-01","salary":"300-350/天","times":"4天/周","time":"5个月","hired":"可转正","scholar":"本科"],
        ["jobname":"软件测试","locate":"上海","createTime":"09-01","salary":"300-350/天","times":"4天/周","time":"5个月","hired":"可转正","scholar":"本科"],
        ["jobname":"容器部署","locate":"上海","createTime":"09-01","salary":"300-350/天","times":"4天/周","time":"5个月","hired":"可转正","scholar":"本科"],
        ["jobname":"容器部署","locate":"上海","createTime":"09-01","salary":"300-350/天","times":"4天/周","time":"5个月","hired":"可转正","scholar":"本科"],
        ["name":"日语老师","locate":"上海","createTime":"09-01","salary":"300-350/天","times":"4天/周","time":"5个月","hired":"可转正","scholar":"本科"],
        ["jobname":"日语编程","locate":"上海","createTime":"09-01","salary":"300-350/天","times":"4天/周","time":"5个月","hired":"可转正","scholar":"本科"],
        ["jobname":"软件培训","locate":"上海","createTime":"09-01","salary":"300-350/天","times":"4天/周","time":"5个月","hired":"可转正","scholar":"本科"],
        ["jobname":"分析师good","locate":"上海","createTime":"09-01","salary":"300-350/天","times":"4天/周","time":"5个月","hired":"可转正","scholar":"本科"],
        ["jobname":"容器部署","locate":"上海","createTime":"09-01","salary":"300-350/天","times":"4天/周","time":"5个月","hired":"可转正","scholar":"本科"],
        ["jobname":"分析师视频","locate":"上海","createTime":"09-01","salary":"300-350/天","times":"4天/周","time":"5个月","hired":"可转正","scholar":"本科"],
        ["jobname":"容器培训","locate":"上海","createTime":"09-01","salary":"300-350/天","times":"4天/周","time":"5个月","hired":"可转正","scholar":"本科"],
        ["jobname":"容器测试","locate":"上海","createTime":"09-01","salary":"300-350/天","times":"4天/周","time":"5个月","hired":"可转正","scholar":"本科"],
    ]
    
    var filterJobLists:[[String:String]] = []
    
    var jobTags:[String] = ["全部","日语","分析师","培训","软件","测试"]
    // 计算类型 闭包值
    var whichTag:String = "" {
        willSet{
            print("change to new \(newValue)")
            self.reloadTable2Data(tag: newValue)
            
        }
        didSet{
            print("current value \(oldValue)")
        }
    }
    
  
    
    
    // back scrollview
    lazy var backScroller:UIScrollView = {
        let s = UIScrollView()
        s.backgroundColor = UIColor.white
        s.delegate = self
        s.bounces = true
        s.showsVerticalScrollIndicator = true
        s.showsHorizontalScrollIndicator = false
        
        
        return s
    }()
    // topview
    
    lazy var topView:UIView={
        
        let v = UIView()
        v.backgroundColor = UIColor.white
        return v
    }()
    
    lazy var scrollitem1:UIButton = {
       let b = UIButton()
        b.setTitle("公司详情", for: .normal)
        b.setTitleColor(UIColor.blue, for: .selected)
        b.setTitleColor(UIColor.gray, for: .normal)
        b.isSelected = true
        b.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        b.addTarget(self, action: #selector(clickButton(button:)), for: .touchUpInside)
        
        return b
    }()
    
    
    lazy var scrollitem2:UIButton = {
        let b = UIButton()
        b.setTitle("在招职位", for: .normal)
        b.setTitleColor(UIColor.blue, for: .selected)
        b.setTitleColor(UIColor.gray, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        b.isSelected = false
        b.addTarget(self, action: #selector(clickButton(button:)), for: .touchUpInside)

        return b
    }()
    
    lazy  var  underLine:UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.blue
        return line
    }()

    //scollerView
    lazy var scroll:UIScrollView = {
        let s = UIScrollView()
        s.bounces = false
        s.delegate = self
        s.showsHorizontalScrollIndicator = false
        s.backgroundColor = UIColor.gray
        s.backgroundColor = UIColor.white
        s.isPagingEnabled = true
        
        
       return s
    }()
    
    
    //tableViews
    lazy var table1:UITableView = {
        let t = UITableView()
        t.backgroundColor = UIColor.white
        t.delegate = self
        t.dataSource = self
        t.register(UINib(nibName:"tagsTableViewCell",bundle:nil), forCellReuseIdentifier: "tag")
        t.register(UINib(nibName:"introduction",bundle:nil), forCellReuseIdentifier: "desc")
        t.register(UINib(nibName:"others",bundle:nil), forCellReuseIdentifier: "other")
        //计算cell高度
        t.rowHeight = UITableViewAutomaticDimension
        t.estimatedRowHeight = 80
        t.separatorStyle = UITableViewCellSeparatorStyle.none
        
       

        return t
    }()
    
    lazy var table2:UITableView = {
        let t = UITableView()
        t.backgroundColor = UIColor.white
        
        t.delegate = self
        t.dataSource = self
        t.register(MainPageCatagoryCell.self, forCellReuseIdentifier: "jobtag")
        t.register(UINib(nibName:"joblist",bundle:nil), forCellReuseIdentifier: "list")
       
        
        
        return t
    }()
    
    lazy var cimage:UIImageView = {
        
        let picture = UIImageView()
        picture.contentMode = .scaleAspectFit
        picture.clipsToBounds = true
        picture.isUserInteractionEnabled = false
        
        
        return picture
    }()
    
    lazy var name:UILabel = {
        let name = UILabel()
        name.font = UIFont.boldSystemFont(ofSize: 14)
        name.textAlignment = .left
        name.textColor = UIColor.black
        return name
    }()
    
    lazy var desc:UILabel = {
        let desc = UILabel()
        desc.font = UIFont.boldSystemFont(ofSize: 14)
        desc.textAlignment = .left
        desc.lineBreakMode = .byWordWrapping
        desc.numberOfLines = 0
        desc.textColor = UIColor.gray
        desc.font = UIFont.systemFont(ofSize: 10)
        return desc
    }()

    
    
    
    
    override func viewDidLoad() {
        
        self.filterJobLists = joblists
        
        let subscribleThis  = UIButton.init(type: .custom)
        subscribleThis.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        subscribleThis.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: subscribleThis)
        
        self.view.backgroundColor = UIColor.white
     
        
        self.view.backgroundColor = UIColor.white
        
        let line = UIView()
        line.backgroundColor = UIColor.gray
        
        cimage.image = UIImage(named:"car")
        name.text  = "国际重车"
        desc.text = "的达瓦大哇大多哇多 哇大无多木哇； 的萌娃；的女娃；的可能我逗你玩的 \n dwaddwadawdwad吊袜带挖达到3232\n d打我的娃打我的吊"
        
        // 不是高度自适应 （限制内容大小）
        self.topView.addSubview(cimage)
        self.topView.addSubview(name)
        self.topView.addSubview(desc)
        
        self.topView.addSubview(line)

        
        self.topView.addSubview(scrollitem1)
        self.topView.addSubview(scrollitem2)
        self.topView.addSubview(underLine)
        
        
//        underLine.frame = CGRect(x: 30, y: self.scroll.frame.height, width: 20, height: 1)
        
        
        table1.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-64)
        table2.frame = CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height-64)
        table1.contentInset = UIEdgeInsetsMake(0, 0, 100, 0)
        table2.contentInset = UIEdgeInsetsMake(0, 0, 100, 0)
        
        table2.tableFooterView  =  UIView()
        self.scroll.addSubview(table1)
        self.scroll.addSubview(table2)
        
        
        backScroller.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height:
        self.view.frame.height+100)
        
        backScroller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)

        backScroller.contentSize = CGSize(width: self.view.frame.width,height:self.view.frame.height)
//        scroll.frame = CGRect(x: 0, y: 164, width: self.view.frame.width, height: self.view.frame.height - 164)
        self.backScroller.addSubview(topView)
        self.backScroller.addSubview(scroll)
        self.view.addSubview(backScroller)
        
        
        
        
        _ = topView.sd_layout().topEqualToView(self.backScroller)?.leftEqualToView(self.backScroller)?.rightEqualToView(self.backScroller)?.heightIs(100)
       
        _ = cimage.sd_layout().topSpaceToView(self.topView,5)?.leftSpaceToView(self.topView,10)?.widthIs(60)?.heightIs(50)
        _ = name.sd_layout().topEqualToView(cimage)?.leftSpaceToView(cimage,10)?.widthIs(200)?.heightIs(20)
        _ = desc.sd_layout().topSpaceToView(name,2)?.leftSpaceToView(cimage,10)?.widthIs(200)?.autoHeightRatio(0)
        
        _ = line.sd_layout().bottomSpaceToView(self.topView,28)?.leftEqualToView(self.topView)?.rightEqualToView(self.topView)?.heightIs(1)
        
        
        _ = scrollitem1.sd_layout().topSpaceToView(line,10)?.leftSpaceToView(self.topView,30)?.widthIs(100)?.heightIs(10)
        _ = scrollitem2.sd_layout().leftSpaceToView(self.scrollitem1,60)?.topSpaceToView(line,10)?.widthIs(100)?.heightIs(10)
        _ = underLine.sd_layout().bottomEqualToView(self.topView)?.centerXEqualToView(self.scrollitem1)?.widthIs(30)?.heightIs(1)
        scroll.contentSize = CGSize(width: self.view.frame.width * 2, height: self.view.frame.height)
        _ = scroll.sd_layout().topSpaceToView(self.topView,1)?.leftEqualToView(self.backScroller)?.bottomEqualToView(self.backScroller)?.rightEqualToView(self.backScroller)
        print(scroll.frame)
        
        
        let l = UILabel()
        l.text = "公司主页"
        l.textAlignment  = .center
        l.textColor = UIColor.black
        l.frame = CGRect(x: 10, y: 10, width: 120, height: 30)
        self.navigationItem.titleView = l
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
       
        self.navigationController?.navigationBar.settranslucent(false)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.settranslucent(true)
    }

   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView  === self.table1 || scrollView == self.table2 {
            
            if self.marginTop != scrollView.contentInset.top{
                self.marginTop = scrollView.contentInset.top
                print("marginTop\(self.marginTop)")
            }
            
            let offset = scrollView.contentOffset.y
            
            let newoffset = self.marginTop + offset
            print(newoffset,self.backScroller.contentOffset,self.backScroller.contentInset)
            // 60 为界限
            if (newoffset > 0  && newoffset < 64){
                self.backScroller.contentInset = UIEdgeInsetsMake(-newoffset, 0, 0, 0)
                //self.backScroller.setContentOffset(CGPoint(x:0, y:newoffset-64),animated: false)
            }else if (newoffset >= 64){
                self.backScroller.contentInset = UIEdgeInsetsMake(-66, 0, 0, 0)

                //self.backScroller.setContentOffset(CGPoint(x: 0, y: 0),animated: false)
            }else if newoffset <= 0 {
                if newoffset >= -64{
                    self.backScroller.contentInset = UIEdgeInsetsMake(-newoffset, 0, 0, 0)
                }else{
                    self.backScroller.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)

                }
            }
            

            
        }
        // 左右滑动
        else if scrollView == self.scroll{
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == table1{
            return 10
        }
        return 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.table1{
            if indexPath.section == 0{
                let cell  = tableView.dequeueReusableCell(withIdentifier: "tag", for: indexPath) as! tagsTableViewCell
                
                cell.tags = tags
                return cell
            }
            else if indexPath.section == 1{
                let cell  = tableView.dequeueReusableCell(withIdentifier: "desc", for: indexPath) as! introduction
                    
                let des = "大哇多无多首先想到的肯定是结束减速的代理方法：scrollViewDscrollViewDidEndDecelerating代理方法的，如果做过用3个界面+scrollView实现循环滚动展示图片，那么基本上都会碰到这么问题。如何准确的监听翻页？我的解决的思路如下达瓦大文大无大无多无大无大无多哇大无多无飞啊飞分为飞飞飞达瓦大文大无大无多哇付达瓦大文大无付多无dwadwadadawdawde"
                
                
                    cell.desc.text = des
                    cell.desc.textColor = UIColor.black
                    return cell
                    
                }
            else{
                let cell  = tableView.dequeueReusableCell(withIdentifier: "other", for: indexPath) as! others
               
                cell.adressDetail.text = "北京市回龙观mol"
                cell.webDetail.text = "http://www.df.com"
                cell.webDetail.textColor = UIColor.blue
                return cell
            }
            
        }
        else{
            // table2 刷新数据不刷新 cell  0
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "jobtag", for: indexPath) as! MainPageCatagoryCell
                cell.createJobTags(name: jobTags, width: 80)
                cell.SetCallBack{
                    [weak self]
                    (str) in
                    self?.whichTag = str
                   
                }
                
                return cell
            }
            
            
            let cell =  tableView.dequeueReusableCell(withIdentifier: "list", for: indexPath) as! joblist
            // 如果没有数据？？
            
            print(indexPath)
            
            var content = filterJobLists[indexPath.row]
            cell.days.text = content["times"]
            cell.name.text = content["jobname"]
            cell.locate.text = content["locate"]
            cell.money.text = content["salary"]
            cell.times.text = content["createTime"]
            
            return cell
        }
        

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.table2 && section == 1{
            return filterJobLists.count
        }
        
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView  == self.table1 {
            return 3
        }
        return 2
    }
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.table1{
                // 计算 labs cell的高度
                if tableView == self.table1 &&  indexPath.section == 0 {
                    return CGFloat((tags.count/3)*50 + 50)
                }
                return UITableViewAutomaticDimension
        }

        return UITableViewAutomaticDimension
    }

    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {


        return UITableViewAutomaticDimension
        
    }
   
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        if tableView == self.table2 && indexPath.section == 1{
            
            // forward to job detail
            let detail = JobDetailViewController()
            detail.infos = self.filterJobLists[indexPath.row]
            detail.isFirst = false
            self.navigationController?.pushViewController(detail, animated: true)
            
        }
    }
    
    
    
    

    // 左右滑动 正确？？
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        if scrollView == self.scroll{
            
            if scrollView.contentOffset.x >= self.view.frame.width{
                self.scrollitem2.isSelected = true
                self.scrollitem1.isSelected = false
                UIView.animate(withDuration: 0.5, animations: {
                    self.underLine.center.x = self.scrollitem2.center.x
                    
                    
                    
                }, completion: nil)
            }
            else{
                self.scrollitem2.isSelected = false
                self.scrollitem1.isSelected = true
                UIView.animate(withDuration: 0.5, animations: {
                    self.underLine.center.x = self.scrollitem1.center.x
                },completion: nil)

            }
            
            print(self.scrollitem1.isSelected,self.scrollitem2.isSelected)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
            
            
        }
    }
    
    
    
    @objc func clickButton(button:UIButton){
        if (button == self.scrollitem1){
            self.scroll.setContentOffset(CGPoint(x:0,y:0), animated: true)
            self.scrollitem2.isSelected = false
            self.scrollitem1.isSelected = true
            UIView.animate(withDuration: 0.5, animations: {
                self.underLine.center.x = self.scrollitem1.center.x
            },completion: nil)
        }
        else if (button == self.scrollitem2){
            self.scroll.setContentOffset(CGPoint(x:self.view.frame.width,y:0), animated: true)
            self.scrollitem2.isSelected = true
            self.scrollitem1.isSelected = false
            UIView.animate(withDuration: 0.5, animations: {
                self.underLine.center.x = self.scrollitem2.center.x
                
                
                
            }, completion: nil)
        }
    }
    func reloadTable2Data(tag:String){
        
        self.filterJobLists.removeAll()
        // 指刷新第1个section的数据
        let positon =  IndexSet(integer: 1)
        if tag == "全部"{
            self.filterJobLists = self.joblists
        }else{
            for list in self.joblists{
                if (list["name"]?.localizedCaseInsensitiveContains(tag))!{
                    self.filterJobLists.append(list)
                }
                
            }
        }
        
        self.table2.reloadSections(positon, with: .none)

        
    }
}
