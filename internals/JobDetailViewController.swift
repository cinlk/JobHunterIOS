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


class JobDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var infos:[String:String]?
    
    
    var table:UITableView?
    
    var sections = 3
    
    //进入cdetail公司详情页面，该页面会查看工作信息，再次返回时时cdetail页面
    var isFirst = true
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.white
        print(infos ?? "none")
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.default
        
        
        
        let uploadButton = UIButton.init(type: .custom)
        uploadButton.setImage(#imageLiteral(resourceName: "upload"), for: .normal)
        uploadButton.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        
        
        let warnButton = UIButton.init(type: .custom)
        warnButton.setImage(#imageLiteral(resourceName: "warn"), for: .normal)
        warnButton.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        
        
        nav?.backgroundColor = UIColor.gray
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: warnButton),UIBarButtonItem.init(customView: uploadButton)]
        
        //table
        
        self.table  = UITableView(frame: self.view.frame, style: .plain)
        
        self.table?.delegate = self
        self.table?.dataSource = self
        // 出去每行线条
        self.table?.separatorStyle = UITableViewCellSeparatorStyle.none

        
        
        self.table?.register(HeaderFoot.self, forHeaderFooterViewReuseIdentifier: "jobheader")
        
        self.table?.register(UINib(nibName:"company", bundle:nil), forCellReuseIdentifier: "companycell")
        self.table?.register(UINib(nibName:"JobDescription", bundle:nil), forCellReuseIdentifier: "joninfos")
        self.table?.register(UINib(nibName:"worklocate", bundle:nil), forCellReuseIdentifier: "locate")
        
        self.view.addSubview(table!)
        
        
        
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
        self.navigationController?.navigationBar.subviews[0].alpha = 1
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setToolbarHidden(true, animated: false)

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
            return 280
        case 2:
            return 90
        default:
            return 44
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(indexPath.section)
        switch indexPath.section {
        
            
        case 0:
            
            let cell  = table?.dequeueReusableCell(withIdentifier: "companycell", for: indexPath) as! company
            cell.cimage.image = UIImage(named: "camera")
            cell.name.text = "测试"
            cell.infos.text = "你好啊|100人|哈哈哈"
            
            return cell
        case 1:
            
            let cell  = table?.dequeueReusableCell(withIdentifier: "joninfos", for: indexPath) as! JobDescription
            cell.demandInfo.text  = "1 \n" + "2 \n" + "3 \n"
            cell.workcontent.text  = "1 \n" + "2 \n" + "3 \n"
            
            return cell
        case 2:
            let cell = table?.dequeueReusableCell(withIdentifier: "locate", for: indexPath) as! worklocate
            cell.locate.text = "北京海淀区"
            cell.details.text = "d挖到哇多无\n" + "吊袜带挖\n"
            return cell
        default:
            
            return  UITableViewCell()
            
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.table{
            // 去除 table header的黏贴性（第一个section移动到header后，header才滑动）
            var sectionHeaderHeight:CGFloat = -64; //sectionHeaderHeight
            
            //向上滑动，top 与父view间距变大，tableview整体上移
            if (scrollView.contentOffset.y > sectionHeaderHeight && scrollView.contentOffset.y < 0) {
                
                scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            //向下滑动
            } else if (scrollView.contentOffset.y <= sectionHeaderHeight) {
                
                scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            // 上移后向显示底部
            }else{
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, -sectionHeaderHeight, 0)
            }
        
        }
            
        
    }

}
