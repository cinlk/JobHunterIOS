

protocol headerCollectionViewDelegate: class {
    
    func chooseItem(name:String)
    
}

class HeaderCollectionView:UIView{
    
    
    private lazy var layout:UICollectionViewLayout = { [unowned self] in
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: self.itemWidth, height: self.itemHeight)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        return layout
    }()
    
    private lazy var collectionView:UICollectionView = { [unowned self] in
        
        
        let collection = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - 10), collectionViewLayout: self.layout)
        collection.contentInset = UIEdgeInsetsMake(0, 15, 0, 10)
        collection.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin]
        collection.register(CollectionItemsCell.self, forCellWithReuseIdentifier: CollectionItemsCell.identity())
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.white
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        
        return collection
        
    }()
    
   
    // delegate
    weak var delegate:headerCollectionViewDelegate?
    
    private var itemWidth:CGFloat = 0
    private var itemHeight:CGFloat = 0
    
    var mode:[ShareItem]?{
        didSet{
           
            collectionView.reloadData()
            
        }
    }
    
    
    init(frame: CGRect, itemSize:CGSize) {
        super.init(frame: frame)
        self.itemHeight = itemSize.height
        self.itemWidth = itemSize.width
        self.backgroundColor = UIColor.viewBackColor()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(collectionView)
        
        
    }
    
    
}

extension HeaderCollectionView:UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mode?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionItemsCell.identity(), for: indexPath) as! CollectionItemsCell
        cell.mode = mode?[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard  let name = mode?[indexPath.row].name else {
            return
        }
        self.delegate?.chooseItem(name: name)
    }
    
    
}
