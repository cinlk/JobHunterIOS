//
//  addMoreCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

class ListItemCell: UITableViewCell {

    
    private lazy var timedate:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()
    
    lazy var modiftButton:UIButton = { [unowned self] in
        let btn = UIButton.init(frame: CGRect.zero)
        btn.backgroundColor = UIColor.clear
        btn.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
        btn.addTarget(self, action: #selector(modify), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var address:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
        
    }()
    
    private lazy var school:UILabel = {
        
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var degree:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var department:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    lazy var company:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    lazy var position:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    lazy var skillType:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    lazy var content:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    
    private lazy var topView:UIView = {
        let v = UIView.init(frame: CGRect.zero)
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    
    typealias modifyCallBack = (_ type:resumeViewType, _ row:Int) -> Void
    
    var modifyCall:modifyCallBack?
    
    private var  row:Int = -1
    private var  type:resumeViewType = .education
    
    
    var mode:(type:resumeViewType, obj:Any,row:Int)?{
        
        didSet{
            self.contentView.subviews.forEach { (view) in
                if view.isKind(of: UILabel.self){
                    view.removeFromSuperview()
                }
            }
            
            switch mode!.type {
            case .education:
                
                buildEducationView(education: mode!.obj as? person_education)
            case .project:
                buildProjectView(projectInfo: mode!.obj as? person_projectInfo)
            case .skill:
                builSkillView(skill: mode!.obj as? person_skills)
            default:
                break
            }
            self.type = mode!.type
            self.row = mode!.row
        }
    }
    

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.addSubview(topView)
        self.contentView.addSubview(modiftButton)

        
        _ = topView.sd_layout().topEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.leftEqualToView(self.contentView)?.heightIs(10)
        _ = modiftButton.sd_layout().rightSpaceToView(self.contentView,10)?.topSpaceToView(topView,5)?.widthIs(40)?.heightIs(30)

    }
  
    
    class func identity()->String {
        return "ListItemCell"
    }

   
}

extension ListItemCell {
    
    @objc func modify(){
        self.modifyCall?(self.type,self.row)
        
    }
    
    private func buildEducationView(education:person_education?){
        
        self.contentView.addSubview(timedate)
        self.contentView.addSubview(address)
        self.contentView.addSubview(school)
        self.contentView.addSubview(degree)
        self.contentView.addSubview(department)
        self.timedate.text = (education?.startTime ?? "") + "-" + (education?.endTime ?? "")
        self.address.text = education?.city
        self.school.text = education?.colleage
        self.degree.text = education?.degree
        self.department.text = education?.department
    
        
 
        _ = timedate.sd_layout().leftSpaceToView(self.contentView,10)?.topEqualToView(modiftButton)?.rightSpaceToView(modiftButton,10)?.heightIs(20)
        _ = address.sd_layout().leftEqualToView(timedate)?.topSpaceToView(timedate,5)?.rightEqualToView(timedate)?.heightIs(20)
        _ = school.sd_layout().leftEqualToView(timedate)?.topSpaceToView(address,5)?.rightEqualToView(timedate)?.heightIs(20)
        _ = degree.sd_layout().leftEqualToView(timedate)?.topSpaceToView(school,5)?.rightEqualToView(timedate)?.heightIs(20)
        _ = department.sd_layout().leftEqualToView(timedate)?.topSpaceToView(degree,5)?.rightEqualToView(timedate)?.heightIs(20)
        
        
    }
    
    private func buildProjectView(projectInfo:person_projectInfo?){
        self.contentView.addSubview(timedate)
         self.contentView.addSubview(address)
        self.contentView.addSubview(company)
        self.contentView.addSubview(position)
        self.contentView.addSubview(content)
        self.timedate.text = (projectInfo?.startTime ?? "") + "-" + (projectInfo?.endTime ?? "")
        self.address.text = projectInfo?.city
        self.company.text = projectInfo?.company
        self.position.text = projectInfo?.position
        self.content.text = projectInfo?.describe
        
        
        _ = timedate.sd_layout().leftSpaceToView(self.contentView,10)?.topEqualToView(modiftButton)?.rightSpaceToView(modiftButton,10)?.heightIs(20)
        _ = address.sd_layout().leftEqualToView(timedate)?.topSpaceToView(timedate,5)?.rightEqualToView(timedate)?.heightIs(20)
        _ = company.sd_layout().leftEqualToView(timedate)?.topSpaceToView(address,5)?.rightEqualToView(timedate)?.heightIs(20)
        _ = position.sd_layout().leftEqualToView(timedate)?.topSpaceToView(company,5)?.rightEqualToView(timedate)?.heightIs(20)
        _ = content.sd_layout().leftEqualToView(timedate)?.topSpaceToView(position,5)?.rightEqualToView(timedate)?.heightIs(20)

        
        
    }
    
    private func builSkillView(skill:person_skills?){
        self.contentView.addSubview(skillType)
        self.contentView.addSubview(content)
        self.skillType.text = skill?.skillType
        self.content.text = skill?.describe
        
         _ = skillType.sd_layout().leftSpaceToView(self.contentView,10)?.topEqualToView(modiftButton)?.rightSpaceToView(modiftButton,10)?.heightIs(20)
        
        _ = content.sd_layout().leftEqualToView(skillType)?.topSpaceToView(skillType,5)?.rightEqualToView(skillType)?.heightIs(20)

        
    }
}

