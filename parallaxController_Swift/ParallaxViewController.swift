//
//  ViewController.swift
//  parallaxController_Swift
//
//  Created by Jeswanth Bonthu on 8/10/14.
//  Copyright (c) 2014 Jeswanth Bonthu. All rights reserved.
//

import UIKit

 class ParallaxViewController: UICollectionViewController {
    
     var sections:            NSArray              = []
     var headerNib:           UINib                = UINib()
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        
        self.sections = ["one","two","three","four","five","six","seven","eight","nine","ten"]
        self.headerNib = UINib(nibName:"StickyHeader", bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
       var layout : ParallaxHeaderLayout = self.collectionViewLayout as ParallaxHeaderLayout 

        if (layout.isKindOfClass(ParallaxHeaderLayout)) {
            layout.parallaxHeaderReferenceSize = CGSizeMake(320, 200) 
        }
        self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0)
        self.collectionView.registerNib(self.headerNib, forSupplementaryViewOfKind:layout.ParallaxHeader, withReuseIdentifier:"header")
    }

  
    //MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return self.sections.count
    }
    
    override func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int
    {
    return 1
    }
    
  
    override func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell!
   {
    var cell : parallaxCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as parallaxCell 
    return cell 
}
    
override func collectionView(collectionView: UICollectionView!, viewForSupplementaryElementOfKind kind: String!, atIndexPath indexPath: NSIndexPath!) -> UICollectionReusableView! {
        
        if (kind == UICollectionElementKindSectionHeader) {
            var cell :parallaxCell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier:"sectionHeader", forIndexPath: indexPath) as parallaxCell
            return cell 
        }
        else if (kind == "ParallexHeader")
        {
            var cell : parallaxCell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath) as parallaxCell
            return cell 
            
        }
        return nil 
    }
//
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


