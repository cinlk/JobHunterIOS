//
//  jobdetailCell.swift
//  internals
//
//  Created by ke.liang on 2017/9/3.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit

class jobdetailCell: UITableViewCell {
    
    var initial: Bool = false
    var model:[String:Any]?
    
    lazy var stackView:UIStackView = {
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.build()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private  func build(){
        
        stackView.frame = CGRect(x: 5, y: 5, width: self.frame.width-10, height: self.frame.height-10)
        self.contentView.addSubview(stackView)
        
       
    }
    
    static func identity()->String{
        return "compuseJobs"
    }
    
    func createCells(items:[String:Any]?){
        
            self.model = items
            // 移除子view,cell是重复利用的
            stackView.subviews.forEach{$0.removeFromSuperview()}
        
            let im = UIStackView()
            im.axis  = .vertical
            im.distribution = .fillProportionally
        
        
            let s1 = UIStackView()
            s1.spacing = 5
            s1.distribution = .fillEqually
            s1.alignment = .bottom
        
            let s2 = UIStackView()
            s2.alignment = .leading
            s2.spacing  = 5
            s2.distribution = .fillEqually
            let s3 = UIStackView()
            s3.alignment = .center
            s3.spacing = 3
            s3.distribution = .fillProportionally
        
        
        
            let imageView = UIImageView()
            let picture = items!["picture"] ?? ""
            imageView.image = UIImage(named: picture as! String)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds  = true
            im.addArrangedSubview(imageView)
            stackView.addArrangedSubview(im)
        
            s2.axis = .vertical
        
        
            let jobName = UILabel()
            jobName.text = items?["jobName"] as? String
            jobName.font = UIFont.boldSystemFont(ofSize: 10)
            s2.addArrangedSubview(jobName)
        
        
            let companyName = UILabel()
            companyName.text = items?["company"] as? String
            companyName.font  = UIFont.systemFont(ofSize: 8)
            companyName.textColor = UIColor.gray
        
            s2.addArrangedSubview(companyName)
        
            let locate = UILabel()
            locate.text  = items?["address"] as? String
            locate.font = UIFont.systemFont(ofSize: 8)
            locate.textColor = UIColor.gray
        
            s2.addArrangedSubview(locate)
            stackView.addArrangedSubview(s2)
        
            let education = UILabel()
            education.text = items!["education"] as? String
            education.font = UIFont.systemFont(ofSize: 8)
            education.textColor = UIColor.black
            s1.addArrangedSubview(education)
            stackView.addArrangedSubview(s1)
        
            //
            s3.axis  = .vertical
            let salary =  UILabel()
            salary.text = items?["salary"] as? String
            salary.font = UIFont.boldSystemFont(ofSize: 8)
            salary.textColor = UIColor.red
            salary.sizeToFit()
            s3.addArrangedSubview(salary)
            let createTime = UILabel()
            createTime.text = items?["create_time"] as? String
            createTime.font = UIFont.systemFont(ofSize: 8)
            createTime.textColor = UIColor.gray
            createTime.sizeToFit()
            s3.addArrangedSubview(createTime)
        
            stackView.addArrangedSubview(s3)
        
        
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    

}
