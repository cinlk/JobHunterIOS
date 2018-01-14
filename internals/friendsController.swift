//
//  friendsController.swift
//  internals
//
//  Created by ke.liang on 2017/10/11.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class friendsController: UIViewController {

    //
    var userinfo:[FriendModel]? = Contactlist.shared.getUsers()
    
    
    lazy var table:UITableView = {
       var table = UITableView.init()
       table.tableFooterView = UIView()
       table.rowHeight = UITableViewAutomaticDimension
       table.register(UINib(nibName:"contactlist", bundle:nil), forCellReuseIdentifier: contactlist.resueIdentifier())
        
       return table
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "好友列表"
        table.frame = self.view.frame
        table.delegate = self
        table.dataSource = self
        
//        var testuser1 = FriendData.init(name: "lk", avart: "avartar")
//        var testuser2 = FriendData.init(name: "devil", avart: "avartar")
//        self.userinfo.add(testuser1)
//        self.userinfo.add(testuser2)
        
        self.view.addSubview(table)

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}

extension friendsController:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: contactlist.resueIdentifier(), for: indexPath) as! contactlist
        
        cell.setupFriendCell(user: userinfo![indexPath.row] )
        cell.selectionStyle  = .none
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userinfo!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = userinfo?[indexPath.row]{
//            let chatView = communication()
//             chatView.chatWith(friend: user, jobCard: nil)
//            self.navigationController?.pushViewController(chatView, animated: true)
        }
        
       
        
        
        
        
    }
    
    

}
