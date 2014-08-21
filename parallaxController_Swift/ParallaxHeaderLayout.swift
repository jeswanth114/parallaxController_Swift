//
//  ParallaxHeaderLayout.swift
//  parallaxController_Swift
//
//  Created by Jeswanth Bonthu on 8/10/14.
//  Copyright (c) 2014 Jeswanth Bonthu. All rights reserved.
//

import Foundation
import UIKit

class ParallaxHeaderLayout: UICollectionViewFlowLayout
{
   
    let ParallaxHeader : String = "ParallexHeader"
    var parallaxHeaderReferenceSize :CGSize = CGSize()  
    var parallaxHeaderMinimumReferenceSize : CGSize =  CGSize()   

    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func prepareLayout(){
      super.prepareLayout()
    }
    
    
    class ParallaxHeaderLayoutAttributes : UICollectionViewLayoutAttributes
    {
        var  progressiveness :CGFloat?
        
        required override init() {
             super.init()
        }
    }
    
override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]!
{
    
    var adjustedRect:CGRect = rect
    adjustedRect.origin.y -= self.parallaxHeaderReferenceSize.height
    var attributesToReturn:[ParallaxHeaderLayoutAttributes] = super.layoutAttributesForElementsInRect(rect) as [ParallaxHeaderLayoutAttributes]
    var allItems : NSMutableArray = NSMutableArray(array:attributesToReturn)
    
    var headers : NSMutableDictionary = NSMutableDictionary()  
    var lastCells : NSMutableDictionary = NSMutableDictionary()  
    var visibleParallexHeader : Bool?  
    
 
    for  attributes in attributesToReturn {
    
        var frame : CGRect = attributes.frame  
        frame.origin.y += self.parallaxHeaderReferenceSize.height  
        attributes.frame = frame  
        
        var indexPath : NSIndexPath = attributes.indexPath
        
        
        var str:String! = attributes.representedElementKind
        if let elemedKind = UICollectionElementKindSectionHeader  {
            headers.setObject(attributes, forKey:indexPath.section)
        }
        else if  let elementKind = UICollectionElementKindSectionFooter {
            // Not implemeneted
        }
        else {
            var indexPath : NSIndexPath = attributes.indexPath  
            var currentAttribute : UICollectionViewLayoutAttributes = lastCells.objectForKey(indexPath.section) as UICollectionViewLayoutAttributes
            
            // Get the bottom most cell of that section
            if ( currentAttribute == false || indexPath.row > currentAttribute.indexPath.row) {
                lastCells.setObject(attributes, forKey: indexPath.section)
            }
            
            if (indexPath.item == 0 && indexPath.section == 0) {
                visibleParallexHeader = true  
            }
        }
        
        attributes.zIndex = 1
    }
    
    // when the visible rect is at top of the screen, make sure we see
    // the parallex header
    if (CGRectGetMinY(rect) <= 0) {
        visibleParallexHeader = true  
    }
    
    
    var numberOfSections : Int = self.collectionView.dataSource.respondsToSelector(Selector("numberOfSectionsInCollectionView:")) ? self.collectionView.dataSource.numberOfSectionsInCollectionView!(self.collectionView) : 1
    
    
    // Create the attributes for the Parallex header
    if (visibleParallexHeader == true && !CGSizeEqualToSize(CGSizeZero, self.parallaxHeaderReferenceSize) && numberOfSections > 0) {
        
        var indexpathTemp :NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        var  currentAttribute : ParallaxHeaderLayoutAttributes = ParallaxHeaderLayoutAttributes(forSupplementaryViewOfKind: ParallaxHeader, withIndexPath: indexpathTemp)
        
        var frame : CGRect = currentAttribute.frame  
        frame.size.width = self.parallaxHeaderReferenceSize.width  
        frame.size.height = self.parallaxHeaderReferenceSize.height  
        
        var bounds :CGRect = self.collectionView.bounds
        var maxY :CGFloat = CGRectGetMaxY(frame)
        
        // make sure the frame won't be negative values
        var y :CGFloat = min(maxY - self.parallaxHeaderMinimumReferenceSize.height, bounds.origin.y + self.collectionView.contentInset.top)  
        var height:CGFloat = max(1, -y + maxY)  
        
        
        var maxHeight :CGFloat = self.parallaxHeaderReferenceSize.height
        var minHeight :CGFloat = self.parallaxHeaderMinimumReferenceSize.height
        var progressiveness :CGFloat = (height - minHeight)/(maxHeight - minHeight)
        currentAttribute.progressiveness = progressiveness  
        
        // if zIndex < 0 would prevents tap from recognized right under navigation bar
        currentAttribute.zIndex = 0  
        
        // When parallaxHeaderAlwaysOnTop is enabled, we will check when we should update the y position
        if (height <= self.parallaxHeaderMinimumReferenceSize.height) {
            var insetTop : CGFloat = self.collectionView.contentInset.top  
            // Always stick to top but under the nav bar
            y = self.collectionView.contentOffset.y + insetTop  
            currentAttribute.zIndex = 2000  
        }
        
        currentAttribute.frame = CGRectMake(frame.origin.x, y, frame.size.width, height)
        
        allItems.addObject(currentAttribute)
        
    }
    
    return allItems  
    }
    
    
  override func layoutAttributesForSupplementaryViewOfKind(elementKind: String!, atIndexPath indexPath: NSIndexPath!) -> UICollectionViewLayoutAttributes!
   {
    
    var attributes : UICollectionViewLayoutAttributes? = super.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath:indexPath)
    
    
    if (attributes == true && elementKind == ParallaxHeader) {
    
     attributes = self.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: indexPath)
            }
    return attributes  
    }
    
    
   override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath!) -> UICollectionViewLayoutAttributes!
   {
    var attributes : UICollectionViewLayoutAttributes = super.layoutAttributesForItemAtIndexPath(indexPath)
    var frame : CGRect = attributes.frame  
    frame.origin.y += self.parallaxHeaderReferenceSize.height  
    attributes.frame = frame  
    return attributes  
    }
    
   override func collectionViewContentSize() -> CGSize
   {
    var size : CGSize = super.collectionViewContentSize()  
    size.height += self.parallaxHeaderReferenceSize.height  
    return size  
    }
    
   override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool
    {
    return true  
    }

    //MARK: OverRides
     override class func layoutAttributesClass() -> AnyClass! {
        return ParallaxHeaderLayoutAttributes.self
    }
    //MARK: Helper
    func updateHeaderAttributes(attributes:UICollectionViewLayoutAttributes, lastCellAttributes:UICollectionViewLayoutAttributes)
    {
        
    var currentBounds:CGRect = self.collectionView.bounds
    attributes.zIndex = 1024
    attributes.hidden = false
    
    var origin:CGPoint = attributes.frame.origin  
    
    var sectionMaxY: CGFloat = CGRectGetMaxY(lastCellAttributes.frame) - attributes.frame.size.height
    var y:CGFloat = CGRectGetMaxY(currentBounds) - currentBounds.size.height + self.collectionView.contentInset.top
       
    var maxY :CGFloat = min (max(y, attributes.frame.origin.y),sectionMaxY)
    
    origin.y = maxY
    
    attributes.frame = CGRectMake(origin.x, origin.y, attributes.frame.size.width, attributes.frame.size.height)
    }


}