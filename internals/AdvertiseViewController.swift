//
//  AdvertiseViewController.swift
//  internals
//
//  Created by ke.liang on 2018/5/26.
//  Copyright © 2018年 lk. All rights reserved.
//

import UIKit
import Kingfisher


class AdvertiseViewController: UIViewController {

    private var timer:Timer?
    
    fileprivate var times:Int = 3{
        didSet{
            countBtn.setTitle("跳过\(times)", for: .normal)
            if times == 0 {
                skip()
            }
        }
    }

    private lazy var backGroundImage:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.isUserInteractionEnabled = true
        image.backgroundColor = UIColor.orange
        if let url = URL.init(string: SingletoneClass.shared.adviseImage?.body?.imageUrl ?? ""){
                image.kf.setImage(with: Source.network(url), placeholder: UIImage.init(named: "bigCar")!, options: nil, progressBlock: nil, completionHandler: nil)
        }
    
        return image
    }()
    
    private lazy var countBtn:UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(skip), for: .touchUpInside)
        btn.alpha = 0.5
        btn.backgroundColor = UIColor.lightGray
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 10
        btn.layer.borderWidth = 0
        btn.setTitle("跳过\(times)", for: .normal)
        return btn
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        startTimer()
        // Do any additional setup after loading the view.
    }
    
    
    

}


extension AdvertiseViewController{
    private func setViews(){
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(backGroundImage)
        backGroundImage.addSubview(countBtn)
        _ = backGroundImage.sd_layout().topEqualToView(self.view)?.leftEqualToView(self.view)?.rightEqualToView(self.view)?.bottomEqualToView(self.view)
        _ = countBtn.sd_layout().topSpaceToView(backGroundImage,40)?.rightSpaceToView(backGroundImage,20)?.widthIs(60)?.heightIs(20)
        
        
    }
    
   
    
    private func startTimer(){
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
                self.times -= 1
            }
            RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        }
    }
    
   @objc private func skip(){
    
        timer?.invalidate()
        timer = nil
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        guard let enter = rootViewController as? EnterAppViewController else {return}
        enter.finishShowAdvertise()
    }
    
  
}
