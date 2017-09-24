//
//  baseSearchViewController.swift
//  internals
//
//  Created by ke.liang on 2017/9/23.
//  Copyright © 2017年 lk. All rights reserved.
//

import UIKit
import YNSearch
import YNDropDownMenu

class baseSearchViewController: UISearchController {

    
    var resultTableView:UITableViewController!
    
    
    override init(searchResultsController: UIViewController?) {
        
        super.init(searchResultsController: searchResultsController)
        
        self.hidesNavigationBarDuringPresentation = false
        self.dimsBackgroundDuringPresentation = true
        self.searchBar.showsCancelButton = false
        self.searchBar.showsBookmarkButton = false

        self.searchBar.searchBarStyle = .default
        self.searchBar.placeholder = "输入查询内容"
        self.searchBar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        // 去掉背景上下黑线
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.barTintColor = UIColor.white
        
        let textfield:UITextField  = self.searchBar.value(forKey: "searchField") as! UITextField
        textfield.backgroundColor = UIColor.white
        textfield.layer.cornerRadius = 14.0
        textfield.layer.borderColor = UIColor(red: 247/255.0, green: 75/255.0, blue: 31/255.0, alpha: 1).cgColor
        textfield.layer.borderWidth = 1
        textfield.layer.masksToBounds = true
        
        
    
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    func customerBookmark(cname:String){
        let im = UIImage()
        
        
        self.searchBar.showsBookmarkButton = true

        self.searchBar.setImage(im.str_image(cname, size: (60.0,60.0)), for: .bookmark, state: .normal)
        
        // fix  size TODO
        self.searchBar.setPositionAdjustment(UIOffsetMake(-250, 0), for: .bookmark)
        
        self.indexOfSearchFieldInSubviews()
        
    }
    
    

    
    func createDropDown(menus:[String],views:[YNDropDownView]){
        
      
        let items:[YNDropDownView] = views
        let conditions = YNDropDownMenu(frame: CGRect(x:0,y:0,width:self.view.frame.width,height:40) , dropDownViews: items, dropDownViewTitles: menus)
        
        
        conditions.setImageWhen(normal: UIImage(named: "arrow_nor"), selected: UIImage(named: "arrow_sel"), disabled: UIImage(named: "arrow_dim"))
        conditions.setLabelColorWhen(normal: .black, selected: .blue, disabled: .gray)
        conditions.setLabelFontWhen(normal: .systemFont(ofSize: 12), selected: .boldSystemFont(ofSize: 12), disabled: .systemFont(ofSize: 12))
        
        
        conditions.backgroundBlurEnabled = true
        conditions.bottomLine.isHidden = false
        let back = UIView()
        back.backgroundColor = UIColor.black
        conditions.blurEffectView = back
        conditions.blurEffectViewAlpha = 0.7
        conditions.setBackgroundColor(color: UIColor.white)
        self.view.addSubview(conditions)
        _ = self.searchResultsController?.view.sd_layout().topSpaceToView(conditions,0.01)?.bottomEqualToView(self.view)?.widthIs(self.view.frame.width)

        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
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

// TODO change size if bookmarkbutton
extension UISearchController{
    
    
    func indexOfSearchFieldInSubviews() -> Int! {
        
        var index: Int!
        let searchBarView = self.searchBar.subviews[0]
        
        for  i in 0..<searchBarView.subviews.count{
            
            
            
            if searchBarView.subviews[i].isKind(of: UITextField.self) {
                print(searchBarView.subviews[i])
                print(searchBarView.subviews[i].subviews.count)
                for subView in searchBarView.subviews[i].subviews{
                    print("-----")
                    // 这只textfield backgroudview 为透明
                    subView.alpha = 0.7
                    //find the search icon and set the width/height for this.
                    /*
                    if let bookmark = subView as? UIImageView{
                        bookmark.frame.size.height = 30
                        bookmark.frame.size.width = 60
                    }
                    */
                    
                    //Find the Bookmark button and set the width/height for this.
                    if let button = subView as? UIButton{
                        print("find button \(button)")
                        button.frame.size.height = 40
                        button.frame.size.width = 40
                    }
                }
                index = i
                //break
            }
        }
        
        return index
    }
    
}
