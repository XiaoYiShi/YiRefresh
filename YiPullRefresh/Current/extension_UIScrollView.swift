//
//  extension_UIScrollView.swift
//  YiRefresh
//
//  Created by 史晓义 on 2018/3/27.
//  Copyright © 2018年 Yi. All rights reserved.
//

import UIKit
import os_object

extension UIScrollView
{
    
    var yi_inset : UIEdgeInsets {
        get {
            if #available(iOS 11.0, *) {
                return self.adjustedContentInset
            }
            return self.contentInset
        }
    }
    var yi_insetT : CGFloat {
        set {
            var inset = self.contentInset
            inset.top = newValue
            if #available(iOS 11.0, *) {
                inset.top -= (self.adjustedContentInset.top - self.contentInset.top)
            }
            self.contentInset = inset
        }
        get {
            return self.yi_inset.top
        }
    }
    var yi_insetB : CGFloat {
        set {
            var inset = self.contentInset
            inset.bottom = newValue
            if #available(iOS 11.0, *) {
                inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom)
            }
            self.contentInset = inset
        }
        get {
            return self.yi_inset.bottom
        }
    }
    var yi_insetL : CGFloat {
        set {
            var inset = self.contentInset
            inset.left = newValue
            if #available(iOS 11.0, *) {
                inset.left -= (self.adjustedContentInset.left - self.contentInset.left)
            }
            self.contentInset = inset
        }
        get {
            return self.yi_inset.left
        }
    }
    var yi_insetR : CGFloat {
        set {
            var inset = self.contentInset
            inset.right = newValue
            if #available(iOS 11.0, *) {
                inset.right -= (self.adjustedContentInset.right - self.contentInset.right)
            }
            self.contentInset = inset
        }
        get {
            return self.yi_inset.right
        }
    }
    var yi_offsetX : CGFloat {
        set {
            var offset = self.contentOffset
            offset.x = newValue
            self.contentOffset = offset
        }
        get {
            return self.contentOffset.x
        }
    }
    var yi_offsetY : CGFloat {
        set {
            var offset = self.contentOffset
            offset.y = newValue
            self.contentOffset = offset
        }
        get {
            return self.contentOffset.y
        }
    }
    var yi_contentW : CGFloat {
        set {
            var size = self.contentSize
            size.width = newValue
            self.contentSize = size
        }
        get {
            return self.contentSize.width
        }
    }
    var yi_contentH : CGFloat {
        set {
            var size = self.contentSize
            size.height = newValue
            self.contentSize = size
        }
        get {
            return self.contentSize.height
        }
    }
}


let YiRefreshHeaderKey : UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "YiRefreshHeaderKey".hashValue)
let YiRefreshFooterKey : UnsafeRawPointer! = UnsafeRawPointer.init(bitPattern: "YiRefreshFooterKey".hashValue)


extension UIScrollView
{
    /** 下拉刷新控件 */
    // mark - header
    var yi_header : YiRefreshHeader! {
        set {
            // 删除旧的，添加新的
            self.yi_header?.removeFromSuperview()
            self.insertSubview(newValue, at: 0)
            // 存储新的
            objc_setAssociatedObject(self, YiRefreshHeaderKey,
                                     newValue, .OBJC_ASSOCIATION_ASSIGN);
        }
        get {
            return objc_getAssociatedObject(self, YiRefreshHeaderKey) as? YiRefreshHeader
        }
    }
    
    /** 上拉刷新控件 */
    // mark - footer
    var yi_footer : YiRefreshFooter! {
        set {
            // 删除旧的，添加新的
            self.yi_footer?.removeFromSuperview()
            self.insertSubview(newValue, at: 0)
            // 存储新的
            objc_setAssociatedObject(self, YiRefreshFooterKey,
                                     newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, YiRefreshFooterKey) as? YiRefreshFooter
        }
    }
    
    // mark - other
    func yi_totalDataCount() -> Int {
        var totalCount = Int(0)
        if let tableView = self as? UITableView
        {
            for section in 0..<tableView.numberOfSections {
                totalCount += tableView.numberOfRows(inSection: section)
            }
        }
        else if let collectionView = self as? UICollectionView
        {
            for section in 0..<collectionView.numberOfSections {
                totalCount += collectionView.numberOfItems(inSection: section)
            }
        }
        return totalCount
    }
}

