//
//  extension_UIView.swift
//  YiRefresh
//
//  Created by 史晓义 on 2018/3/27.
//  Copyright © 2018年 Yi. All rights reserved.
//

import UIKit

//public struct YiView_ex
//{
//    var view : UIView!
//    internal init(view: UIView) {
//        self.view = view
//    }
//    
//    var x : CGFloat {
//        set {
//            var frame = view.frame
//            frame.origin.x = newValue
//            view.frame = frame
//        }
//        get {
//            return view.frame.origin.x
//        }
//    }
//    var y : CGFloat {
//        set {
//            var frame = view.frame
//            frame.origin.y = newValue
//            view.frame = frame
//        }
//        get {
//            return view.frame.origin.y
//        }
//    }
//    var w : CGFloat {
//        set {
//            var frame = view.frame
//            frame.size.width = newValue
//            view.frame = frame
//        }
//        get {
//            return view.frame.size.width
//        }
//    }
//    var h : CGFloat {
//        set {
//            var frame = view.frame
//            frame.size.height = newValue
//            view.frame = frame
//        }
//        get {
//            return view.frame.size.height
//        }
//    }
//    var size : CGSize {
//        set {
//            var frame = view.frame
//            frame.size = newValue
//            view.frame = frame
//        }
//        get {
//            return view.frame.size
//        }
//    }
//    var origin : CGPoint {
//        set {
//            var frame = view.frame
//            frame.origin = newValue
//            view.frame = frame
//        }
//        get {
//            return view.frame.origin
//        }
//    }
//}
//public extension UIView {
//    public var yi: YiView_ex {
//        return YiView_ex(view: self)
//    }
//}
//





extension UIView {
    
    var yi_x : CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }
    var yi_y : CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }
    var yi_w : CGFloat {
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.width
        }
    }
    var yi_h : CGFloat {
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        get {
            return self.frame.size.height
        }
    }
    var yi_size : CGSize {
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
        get {
            return self.frame.size
        }
    }
    var yi_origin : CGPoint {
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin
        }
    }
}


