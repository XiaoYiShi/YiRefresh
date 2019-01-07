//
//  YiRefreshConst.swift
//  YiRefresh
//
//  Created by 史晓义 on 2018/3/27.
//  Copyright © 2018年 Yi. All rights reserved.
//

import UIKit


// 日志输出
func YiRefreshLog<T>(_ message: T,
                 file: String = #file,
                 method: String = #function,
                 line: Int = #line)
{
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}

extension UIColor
{
    // RGB颜色
    convenience init(r: Int, g: Int, b: Int) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: 1)
    }
    struct YiRefresh {
        static let LabelText = UIColor.init(r: 90, g: 90, b: 90)
    }
}
extension UIFont
{
    struct YiRefresh
    {
        static let Label = UIFont.boldSystemFont(ofSize: 14)
    }
}
extension CGFloat {
    struct YiRefresh {
        static let labelLeftInset   : CGFloat   = 25
        static let headerHeight     : CGFloat   = 54.0
        static let footerHeight     : CGFloat   = 44.0
    }
}

// MARK: - 动画时间
extension TimeInterval {
    struct YiRefresh {
        static let fast : Double    = 0.25
        static let slow : Double    = 0.4
    }
}





// 常量
enum YiRefreshText
{
    enum header : String
    {
        case idle               = "YiRefresh_HeaderText_Idle"
        case pulling            = "YiRefresh_HeaderText_Pulling"
        case refreshing         = "YiRefresh_HeaderText_Refreshing"
    }
    enum footer {
        enum auto : String {
            case idle           = "YiRefresh_AutoFooterText_Idle"
            case refreshing     = "YiRefresh_AutoFooterText_Refreshing"
            case noMore         = "YiRefresh_AutoFooterText_NoMoreData"
        }
        enum back : String {
            case idle           = "YiRefresh_BackFooterText_Idle"
            case pulling        = "YiRefresh_BackFooterText_Pulling"
            case refreshing     = "YiRefresh_BackFooterText_Refreshing"
            case noMore         = "YiRefresh_BackFooterText_NoMoreData"
        }
    }
    enum time:String {
        case last               = "YiRefresh_HeaderText_LastTime"
        case today              = "YiRefresh_HeaderText_DateToday"
        case none               = "YiRefresh_HeaderText_NoneLastDate"
    }
    enum key : String {
        case contentOffset      = "contentOffset"
        case contentInset       = "contentInset"
        case contentSize        = "contentSize"
        case panState           = "state"
        case lastUpdatedTime    = "YiRefreshHeaderLastUpdatedTimeKey"
    }
}



//class YiRefresh: NSObject
//{
//    struct Text {
//        struct header
//        {
//            static let idle             = "YiRefresh_HeaderText_Idle"
//            static let pulling          = "YiRefresh_HeaderText_Pulling"
//            static let refreshing       = "YiRefresh_HeaderText_Refreshing"
//        }
//        struct footer
//        {
//            struct auto
//            {
//                static let idle         = "YiRefresh_AutoFooterText_Idle"
//                static let refreshing   = "YiRefresh_AutoFooterText_Refreshing"
//                static let noMore       = "YiRefresh_AutoFooterText_NoMoreData"
//            }
//            struct back
//            {
//                static let idle         = "YiRefresh_BackFooterText_Idle"
//                static let pulling      = "YiRefresh_BackFooterText_Pulling"
//                static let refreshing   = "YiRefresh_BackFooterText_Refreshing"
//                static let noMore       = "YiRefresh_BackFooterText_NoMoreData"
//            }
//        }
//        struct time
//        {
//            static let last             = "YiRefresh_HeaderText_LastTime"
//            static let today            = "YiRefresh_HeaderText_DateToday"
//            static let none             = "YiRefresh_HeaderText_NoneLastDate"
//        }
//        struct key
//        {
//            static let contentOffset    = "contentOffset"
//            static let contentInset     = "contentInset"
//            static let contentSize      = "contentSize"
//            static let panState         = "state"
//            static let lastUpdatedTime  = "YiRefreshHeaderLastUpdatedTimeKey"
//        }
//
//
//    }
//}
