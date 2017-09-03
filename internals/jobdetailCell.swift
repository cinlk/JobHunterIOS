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
    
    
    
    func createCells(items:[String:String]?){
        
            // 移除子view,cell是重复利用的
            stackView.subviews.forEach{$0.removeFromSuperview()}
            let im = UIStackView()
            im.axis  = .vertical
            im.distribution = .fillProportionally
            let s1 = UIStackView()
            s1.axis = .horizontal
            s1.spacing = 3
            s1.alignment = .bottom
            let s2 = UIStackView()
            s2.alignment = .leading
            s2.spacing  = 5
            s2.distribution = .fillEqually
            let s3 = UIStackView()
            s3.alignment = .center
            s3.spacing = 0
            let imageView = UIImageView()
            imageView.image = UIImage(named: (items?["image"]!)!)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds  = true
            im.addArrangedSubview(imageView)
            stackView.addArrangedSubview(im)
        
            s2.axis = .vertical
        
        
            let jobName = UILabel()
            jobName.text = items?["jobname"]
            jobName.font = UIFont.boldSystemFont(ofSize: 10)
            s2.addArrangedSubview(jobName)
        
        
            let companyName = UILabel()
            companyName.text = items?["companyName"]
            companyName.font  = UIFont.systemFont(ofSize: 8)
            companyName.textColor = UIColor.gray
        
            s2.addArrangedSubview(companyName)
        
            let locate = UILabel()
            locate.text  = items?["locate"]
            locate.font = UIFont.systemFont(ofSize: 6)
            locate.textColor = UIColor.gray
            s1.addArrangedSubview(locate)
            let times = UILabel()
            times.text = items?["times"]
            times.font = UIFont.systemFont(ofSize: 6)
            times.textColor = UIColor.gray
            s1.addArrangedSubview(times)
        
            s2.addArrangedSubview(s1)
            stackView.addArrangedSubview(s2)
            
            //
            s3.axis  = .vertical
            let salary =  UILabel()
            salary.text = items?["salary"]
            salary.font = UIFont.boldSystemFont(ofSize: 8)
            salary.textColor = UIColor.red
            s3.addArrangedSubview(salary)
            let createTime = UILabel()
            createTime.text = items?["createTime"]
            createTime.font = UIFont.systemFont(ofSize: 8)
            createTime.textColor = UIColor.gray
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
