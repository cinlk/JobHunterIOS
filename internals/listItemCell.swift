//
//  addMoreCell.swift
//  internals
//
//  Created by ke.liang on 2018/2/12.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit

@objcMembers class ListItemCell: UITableViewCell {

    
    private lazy var timedate:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)
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
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)

        return label
        
    }()
    
    private lazy var school:UILabel = {
        
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)

        return label
    }()
    
    private lazy var degree:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)

        return label
    }()
    
    private lazy var department:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)

        return label
    }()
    
    lazy var company:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)

        return label
    }()
    
    lazy var position:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)

        return label
    }()
    
    lazy var skillType:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW)

        return label
    }()
    
    // project 内容
    lazy var content:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20)
        return label
    }()
    
    // skill 内容
    lazy var skillcontent:UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.setSingleLineAutoResizeWithMaxWidth(ScreenW - 20)

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
    
    
    dynamic var mode:Any?{
        
        didSet{
            
            
            self.contentView.subviews.forEach { (view) in
                if view.isKind(of: UILabel.self){
                    //view.sd_resetLayout()
                    
                    view.removeFromSuperview()
                }
            }
            
            // 根据类型 设置布局
            switch self.type {
            case .education:
                buildEducationView(education: mode as? personEducationInfo)
            case .intern:
                buildInternView(projectInfo: mode as? personInternInfo)
            case .skill:
                builSkillView(skill: mode as? personSkillInfo)
            default:
                break
            }
            
        }
    }
    

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.addSubview(topView)
        self.contentView.addSubview(modiftButton)
        
        _ = topView.sd_layout().topEqualToView(self.contentView)?.rightEqualToView(self.contentView)?.leftEqualToView(self.contentView)?.heightIs(10)
        _ = modiftButton.sd_layout().rightSpaceToView(self.contentView,10)?.topSpaceToView(topView,5)?.widthIs(40)?.heightIs(30)
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    class func identity()->String {
        return "ListItemCell"
    }
    
    func setrow(type:resumeViewType, row:Int){
        self.type = type
        self.row = row
    }

   
}

extension ListItemCell {
    
    @objc func modify(){
        self.modifyCall?(self.type,self.row)
        
    }
    
    private func buildEducationView(education:personEducationInfo?){
        
        let views:[UIView] = [timedate, address, school, degree, department]
        self.contentView.sd_addSubviews(views)
        
        
        self.timedate.text = (education?.startTimeString ?? "")  + "-" + (education?.endTimeString ?? "")
        self.address.text = education?.city
        self.school.text = education?.colleage
        self.degree.text = education?.degree
        self.department.text = education?.department
    
        
 
        _ = timedate.sd_layout().leftSpaceToView(self.contentView,10)?.topEqualToView(modiftButton)?.autoHeightRatio(0)
        _ = address.sd_layout().leftEqualToView(timedate)?.topSpaceToView(timedate,5)?.autoHeightRatio(0)
        _ = school.sd_layout().leftEqualToView(timedate)?.topSpaceToView(address,5)?.autoHeightRatio(0)
        _ = degree.sd_layout().leftEqualToView(timedate)?.topSpaceToView(school,5)?.autoHeightRatio(0)
        _ = department.sd_layout().leftEqualToView(timedate)?.topSpaceToView(degree,5)?.autoHeightRatio(0)
        
        self.setupAutoHeight(withBottomView: department, bottomMargin: 5)
        
    }
    
    private func buildInternView(projectInfo:personInternInfo?){
        
        let views:[UIView] = [timedate, address, company, position, content]
        self.contentView.sd_addSubviews(views)
        
        self.timedate.text = (projectInfo?.startTimeString ?? "") + "-" + (projectInfo?.endTimeString ?? "")
        self.address.text = projectInfo?.city
        self.company.text = projectInfo?.company
        self.position.text = projectInfo?.position
        self.content.text = projectInfo?.describe
        
        
        _ = timedate.sd_layout().leftSpaceToView(self.contentView,10)?.topEqualToView(modiftButton)?.autoHeightRatio(0)
        _ = address.sd_layout().leftEqualToView(timedate)?.topSpaceToView(timedate,5)?.autoHeightRatio(0)
        _ = company.sd_layout().leftEqualToView(timedate)?.topSpaceToView(address,5)?.autoHeightRatio(0)
        _ = position.sd_layout().leftEqualToView(timedate)?.topSpaceToView(company,5)?.autoHeightRatio(0)
        _ = content.sd_layout().leftEqualToView(timedate)?.topSpaceToView(position,5)?.autoHeightRatio(0)
        
        content.setMaxNumberOfLinesToShow(1)
        self.setupAutoHeight(withBottomView: content, bottomMargin: 5)
    
    }
    
    private func builSkillView(skill:personSkillInfo?){
        
        
        self.contentView.addSubview(skillType)
        self.contentView.addSubview(skillcontent)
        self.skillType.text = skill?.skillType
        self.skillcontent.text = skill?.describe
        
         _ = skillType.sd_layout().leftSpaceToView(self.contentView,10)?.topEqualToView(modiftButton)?.autoHeightRatio(0)
        
        _ = skillcontent.sd_layout().leftEqualToView(skillType)?.topSpaceToView(skillType,20)?.autoHeightRatio(0)
        
        skillcontent.setMaxNumberOfLinesToShow(1)

        self.setupAutoHeight(withBottomView: skillcontent, bottomMargin: 5)
        
    }
}

