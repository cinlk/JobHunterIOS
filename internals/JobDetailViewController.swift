//
//  JobDetailViewController.swift
//  internals
//
//  Created by ke.liang on 2017/9/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

//内置分享sdk
import Social

class JobDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var infos:[String:String]?
    
    
    var table:UITableView?
    
    var sections = 3
    
    //进入cdetail公司详情页面，该页面会查看工作信息，再次返回时时cdetail页面
    var isFirst = true
    
    
    // test string
    var needed =  "3年以上互联网产品工作经验，经历过较大体量用户前后端产品项目\n 思维活跃，有独立想法，有情怀，喜欢电影行业\n 善于业务整体规划、任务模块优先级拆解、能够主导产品生命周期全流程\n 具备良好的沟通技巧和团队合作精神，有带团队经验者优先 \n高度执行力，能够独当一面，善于推动团队效率不断提升"
    
    var desc = "1、负责租房频道整体流量运营及制定获客策略，辅助制定租房频道市场营销、推广和渠道合作策略；\n 2、合理的制定目标及市场预算分配 \n 3、负责对外媒体合作和商务拓展活动；\n 4、推动租房频道线上推广及线下活动的策划、组织和执行工作； \n 5、协调运营、产品及技术等团队推动产品优化提升获客效果 \n 6、对市场信息敏感，及时汇报且要做出预判投放解决方案。"
    
    var shareapps:shareView?
    
    var centerY:CGFloat!
    
    var darkView :UIView!
    
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.white
        print(infos ?? "none")
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.default
        
        
        
        let uploadButton = UIButton.init(type: .custom)
        uploadButton.setImage(#imageLiteral(resourceName: "upload"), for: .normal)
        uploadButton.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        
        uploadButton.addTarget(self, action: #selector(share), for: .touchUpInside)
        let warnButton = UIButton.init(type: .custom)
        warnButton.setImage(#imageLiteral(resourceName: "warn"), for: .normal)
        warnButton.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        
        
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: warnButton),UIBarButtonItem.init(customView: uploadButton)]
        
        //table
        
        self.table  = UITableView(frame: self.view.frame, style: .plain)
        
        self.table?.delegate = self
        self.table?.dataSource = self
        
        //自适应cell高度
        self.table?.rowHeight = UITableViewAutomaticDimension
        self.table?.estimatedRowHeight = 80
        self.table?.separatorStyle = UITableViewCellSeparatorStyle.none

        
        self.table?.register(HeaderFoot.self, forHeaderFooterViewReuseIdentifier: "jobheader")
        
        self.table?.register(UINib(nibName:"company", bundle:nil), forCellReuseIdentifier: "companycell")
        self.table?.register(UINib(nibName:"JobDescription", bundle:nil), forCellReuseIdentifier: "joninfos")
        self.table?.register(UINib(nibName:"worklocate", bundle:nil), forCellReuseIdentifier: "locate")
        
        self.view.addSubview(table!)
        
        
        //
        shareapps =  shareView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 100))
        centerY = shareapps?.centerY
        
        shareapps?.exit = self
        
        // 加入最外层窗口
        let windows = UIApplication.shared.windows.last
        
        windows?.addSubview(shareapps!)
        
        darkView = UIView()
        darkView.frame = CGRect(x: 0, y: 0, width:UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height)
        darkView.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.5) // 设置半透明颜色
        
        darkView.isUserInteractionEnabled = true // 打开用户交互
        
        let singTap = UITapGestureRecognizer(target: self, action:#selector(self.handleSingleTapGesture)) // 添加点击事件
        
        singTap.numberOfTouchesRequired = 1
        
        darkView.addGestureRecognizer(singTap)
        
        
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "职位详情"
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        let sendResume = UIButton.init(type: .custom)
        sendResume.setTitle("发送简历", for: .normal)
        sendResume.setTitleColor(UIColor.white, for: .normal)
        sendResume.backgroundColor = UIColor.green
        sendResume.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
       
        
        sendResume.layer.borderColor = UIColor.black.cgColor
        sendResume.layer.borderWidth  = 1.0
        
        let talk = UIButton.init(type: .custom)
        
        talk.setTitle("和ta聊聊", for: .normal)
        talk.setTitleColor(UIColor.green, for: .normal)
        talk.backgroundColor = UIColor.white
        talk.frame = CGRect(x: 0, y: 0, width: 180, height: 40)
        
        talk.layer.borderColor = UIColor.black.cgColor
        talk.layer.borderWidth  = 1.0
        self.toolbarItems = [UIBarButtonItem.init(customView: sendResume),
        UIBarButtonItem.init(customView: talk)]
        
        // 不透明
        self.navigationController?.navigationBar.settranslucent(false)
        //self.table?.setContentOffset(CGPoint(x:0,y:-64), animated: false)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.navigationController?.navigationBar.settranslucent(true)


    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   // table
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 80
        }
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch  section {
        case 0:
            let header = table?.dequeueReusableHeaderFooterView(withIdentifier: "jobheader") as! HeaderFoot
            header.contentView.backgroundColor = UIColor.white
            header.createInfos(jobstring: infos?["jobname"], locatestring: infos?["locate"], salarystring: infos?["salary"], timestring: infos?["times"], day: infos?["time"], scholars: infos?["scholar"], hires: infos?["hired"])
            
            return header

        default:
            return nil
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.table?.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section  == 0 {
            
            if isFirst{
                print("公司主页")
                self.navigationItem.title = ""
                let detail = cdetails()
            
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(detail, animated: true)

            }
            else{
                self.navigationController?.popViewController(animated: true)
            }
         
            
        }
        else if indexPath.section  == 2{
            // show mapApp
            let address = "北京市融科资讯中心"
            
            
            // import find address
            
            
            let geocoder = CLGeocoder()
            var place:CLLocationCoordinate2D?
                
            geocoder.geocodeAddressString(address) {
                    (placemarks, error) in
                    guard error == nil else {
                        print(error!)
                        return
                    }
                    place = placemarks?.first?.location?.coordinate
                let alert  =  PazNavigationApp.directionsAlertController(coordinate: place!, name: address, title: "选择地图", message: nil)
                self.present(alert, animated: true, completion: nil)

            }
            
            
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 60
        case 1:
            return UITableViewAutomaticDimension
        case 2:
            return UITableViewAutomaticDimension
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        

        return UITableViewAutomaticDimension
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(indexPath.section)
        switch indexPath.section {
        
            
        case 0:
            
            let cell  = table?.dequeueReusableCell(withIdentifier: "companycell", for: indexPath) as! company
            cell.cimage.image = UIImage(named: "camera")
            cell.name.text = "vmware公司"
            cell.infos.text = "上市企业|1万人|不加班"
            
            return cell
        case 1:
            
            let cell  = table?.dequeueReusableCell(withIdentifier: "joninfos", for: indexPath) as! JobDescription
            cell.demandInfo.text  = needed
            cell.workcontent.text  = desc
            
            return cell
        case 2:
            let cell = table?.dequeueReusableCell(withIdentifier: "locate", for: indexPath) as! worklocate
            cell.locate.text = "北京海淀区"
            cell.details.text = "北四环\n" + "海淀北二街\n"
            return cell
        default:
            
            return  UITableViewCell()
            
        }
        
    }
    
    // TODO  section 和header 一起滑动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.table{
            // 去除 table header的黏贴性（第一个section移动到header后，header才滑动）
            let sectionHeaderHeight:CGFloat = -64; //sectionHeaderHeight
            //向上滑动，top 与父view间距变大，tableview整体上移
            if (scrollView.contentOffset.y > sectionHeaderHeight && scrollView.contentOffset.y < 0) {
                
                scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            //向下滑动
            } else if (scrollView.contentOffset.y <= sectionHeaderHeight) {
                
                scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            // 上移后向显示底部  > 0
                
            }else if scrollView.contentOffset.y >= 0 {
                
                if scrollView.contentOffset.y <= 64{
                    scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, -sectionHeaderHeight + 40, 0)
                }else{
                // 因为cell高度自适应，多留出40.
                scrollView.contentInset = UIEdgeInsetsMake(-64, 0, -sectionHeaderHeight + 40, 0)
            
                }
            }
        
        }
            
        
    }

}

extension JobDetailViewController{
    
    // 分享
    func share(){
    //在 navigation 层view 添加darkview（蒙层) 遮挡整个界面
    
    self.navigationController?.view.addSubview(darkView)
    //self.view.addSubview(darkView)
        UIView.animate(withDuration: 0.5, animations: {
            
            self.shareapps?.frame = CGRect(x: 0, y: self.view.frame.height-35, width: self.view.frame.width, height: 100)
        }, completion: nil)
        
        
        
    }
    
    func showAlertMessage(message: String!) {
        let alertController = UIAlertController(title: "EasyShare", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
    
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension JobDetailViewController:closeshare{
    func exit() {
        
        darkView.removeFromSuperview()
        UIView.animate(withDuration: 0.5, animations: {
            
            self.shareapps?.centerY =  self.centerY
        }, completion: nil)

    }
}

extension JobDetailViewController{
    
    func handleSingleTapGesture() {
         // 点击移除半透明的View
        self.exit()
        
    }
}
