//
//  YYLottieAnimationManager.swift
//  Template
//
//  Created by nevsee on 2021/12/29.
//

import Foundation
import UIKit

/// 记录动画文件名称和动画实际大小
@objcMembers class YYLottieAnimationManager : NSObject {
    public static let loadingRingName: String = "yy_loading_ring"
    public static let loadingRingSize: CGSize = CGSize.init(width: 30, height: 30)
    
    public static let loadingDotName: String = "yy_loading_dot"
    public static let loadingDotSize: CGSize = CGSize.init(width: 35, height: 35)
}
