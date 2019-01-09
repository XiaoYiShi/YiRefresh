//
//  extension_Bundle.swift
//  YiRefresh
//
//  Created by 史晓义 on 2018/3/27.
//  Copyright © 2018年 Yi. All rights reserved.
//

import UIKit


extension Bundle {
    private static var refreshBundle : Bundle!
    private static var arrowImage : UIImage!
    
    class func yi_refreshBundle() -> Bundle {
        if (refreshBundle == nil) {
            // 这里不使用mainBundle是为了适配pod 1.x和0.x
            refreshBundle = Bundle.init(
                path: Bundle.init(for: YiRefreshComponent.self).path(forResource: "YiRefresh",
                                                                     ofType: "bundle")!
            )
        }
        return refreshBundle
    }
    class func yi_arrowImage() -> UIImage {
        if (arrowImage == nil) {
            arrowImage = UIImage.init(
                contentsOfFile: yi_refreshBundle().path(forResource: "arrow@2x", ofType: "png")!
                )?.withRenderingMode(.alwaysTemplate)
        }
        return arrowImage
    }
    class func yi_localizedStringForKey(key:String) -> String {
        return yi_localizedStringForKey(key: key, value: nil);
    }
    private static var bundle : Bundle? {
        get {
            // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
            var language = Locale.preferredLanguages.first! as NSString
            if language.hasPrefix("en") {
                language = "en"
            } else if language.hasPrefix("zh") {
                if language.range(of: "Hans").location != NSNotFound {
                    language = "zh-Hans" // 简体中文
                } else {// zh-Hant\zh-HK\zh-TW
                    language = "zh-Hant" // 繁體中文
                }
            } else {
                language = "en"
            }
            // 从YiRefresh.bundle中查找资源
            return Bundle.init(path: yi_refreshBundle().path(forResource: language as String, ofType: "lproj")!)!
        }
    }
    class func yi_localizedStringForKey(key:String, value:String?) -> String
    {
        let newValue = bundle?.localizedString(forKey: key, value: value, table: nil)
        return Bundle.main.localizedString(forKey: key, value: newValue, table: nil) 
    }
}

