//
//  jobstatusView.swift
//  internals
//
//  Created by ke.liang on 2017/10/2.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit



class jobstatusView: UIViewController {

    var jobDetail:Dictionary<String,String>!
    var current:Dictionary<String,String>!
    var status:[Array<String>]!
    var sCount = 0
    var table:UITableView!
    
    // bottom talk view
    lazy var bottomView:UIView = {
        var v = UIView()
        v.backgroundColor =  UIColor.lightGray
        
        var talk = UIButton()
        talk.setTitle("和TA聊聊", for: .normal)
        talk.setTitleColor(UIColor.white, for: .normal)
        talk.backgroundColor = UIColor.green
        talk.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        talk.titleLabel?.textAlignment  = .center
        talk.addTarget(self, action: #selector(talkhr), for: .touchUpInside)
        
        v.addSubview(talk)
        _ = talk.sd_layout().leftSpaceToView(v,10)?.rightSpaceToView(v,10)?.topSpaceToView(v,5)?.bottomSpaceToView(v,5)
        return v
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sCount = status.count-1
        table = UITableView.init(frame: self.view.frame)
        table.delegate = self
        table.dataSource = self
        //顶部职位cell
        self.table.register(jobdetailCell.self, forCellReuseIdentifier: "top")
        // 描述cell 状态和反馈
        self.table.register(jobstatusDesCell.self, forCellReuseIdentifier: "middle")
        // 状态变化cell
        self.table.register(UINib(nibName:"statustage", bundle:nil), forCellReuseIdentifier: "bottom")
        
        
        self.table.tableFooterView =  UIView()
        self.table.isScrollEnabled = false
        self.table.separatorStyle = .none
        self.navigationItem.title  = "投递记录"
        
        self.view.addSubview(table)
        
        self.view.addSubview(bottomView)
        _ = bottomView.sd_layout().bottomEqualToView(self.view)?.widthIs(self.view.frame.width)?.heightIs(45)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension jobstatusView:UITableViewDelegate,UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return status.count
        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("initial cell")
        switch indexPath.section {
        case 0:
            
            let cell =  table.dequeueReusableCell(withIdentifier: "top", for: indexPath) as! jobdetailCell
            cell.createCells(items: jobDetail)
            
            let image = UIImageView()
            image.clipsToBounds = true
            image.frame.size = CGSize(width: 15, height: 15)
            image.image = UIImage(named: "rightforward")
            
            cell.contentView.addSubview(image)
            _ = image.sd_layout().rightSpaceToView(cell.contentView,5)?.centerYEqualToView(cell.contentView)?.heightIs(15)?.widthIs(15)
            
            // 修改里面stackview frame
            cell.stackView.frame.size = CGSize(width: cell.frame.width-10, height: cell.frame.height-10)
            
            return cell
            
        case 1:
            let cell = table.dequeueReusableCell(withIdentifier: "middle", for: indexPath) as! jobstatusDesCell
            cell.cstatus.text = current["status"]
            
            if current["response"] != nil{
                let res:UILabel =  UILabel()
                res.text = "投递反馈"
                res.font = UIFont.boldSystemFont(ofSize: 12)
                cell.contentView.addSubview(res)
                _  = res.sd_layout().leftSpaceToView(cell.contentView,10)?.topSpaceToView(cell.label,3)?.widthIs(60)?.heightIs(15)
                let data = UILabel()
                data.font = UIFont.boldSystemFont(ofSize: 12)
                cell.contentView.addSubview(data)
                data.text  = current["response"]
                _  = data.sd_layout().leftSpaceToView(res,10)?.topEqualToView(res)?.widthIs(200)?.heightIs(15)
                
            }
            // 不显示点击
            cell.selectionStyle  = .none
            return cell
            
        case 2:
            
            var cell = table.dequeueReusableCell(withIdentifier: "bottom", for: indexPath) as? statustage
            if cell == nil{
                cell =  statustage()
            }
            if sCount  == 0{
               
                cell?.status.text =  status[0][0]
                cell?.time.text  = status[0][1]
                cell?.logo.image =  #imageLiteral(resourceName: "checked")
                
            }else{
                let data = status[indexPath.row]
                cell?.logo.image = #imageLiteral(resourceName: "checked1")
                cell?.status.text = data[0]
                cell?.time.text = data[1]
                // 最后一个cell
                if indexPath.row  == sCount{
                   
                    cell?.upline.isHidden = false
                }else if indexPath.row == 0{
                    cell?.logo.image = #imageLiteral(resourceName: "checked")
                    cell?.downline.isHidden = false
                }else{
                    cell?.upline.isHidden = false
                    cell?.downline.isHidden = false
                }
                
            }
            // 不显示点击
            cell?.selectionStyle  = .none
            return cell!
            
        default:
            let cell = UITableViewCell()
            return cell
        }
        
        
        
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            
            return 60
        case 1:
             if current["response"] != nil{
                return 50
             }
             return 30
        case 2:
            return 66
        default:
            return 50
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header =  UITableViewHeaderFooterView()
        header.backgroundColor = UIColor.lightGray
        return header
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if  indexPath.section == 0 {
            let detail =  JobDetailViewController()
            detail.infos = jobDetail
            // 子视图 返回lable修改为空
            let backButton =  UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
            self.navigationItem.backBarButtonItem = backButton
            self.navigationController?.pushViewController(detail, animated: true)
        }
       
    }
    
    
}


extension jobstatusView{
    func talkhr(sender:UIButton){
        // step 1  add to friend list
        let HR:FriendData = FriendData.init(name: jobDetail["companyName"]!+"@"+"hr", avart: "jodel")
        Contactlist.shared().addUser(user: HR)
        
        
        
        // show chat view and job description cell
        let chatView = communication()
        chatView.chatWith(friend: HR,jobCard:self.jobDetail)
        self.navigationController?.pushViewController(chatView, animated: true)
        
    }
}

class jobstatusDesCell:UITableViewCell{
    
    
    var label:UILabel!
    var cstatus:UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        label = UILabel()
        label.text = "当前状态"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        
        cstatus = UILabel()
        cstatus.font = UIFont.boldSystemFont(ofSize: 12)
        self.contentView.addSubview(cstatus)
        
        self.contentView.addSubview(label)
        _ = label.sd_layout().leftSpaceToView(self.contentView,10)?.topSpaceToView(self.contentView,5)?.widthIs(60)?.heightIs(15)
        
        _ = cstatus.sd_layout().leftSpaceToView(label,10)?.topEqualToView(label)?.widthIs(120)?.heightIs(15)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



