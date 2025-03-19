//
//  ZMUIConfig.swift
//  ZLUIUtilities
//
//  Created by 朱猛 on 2025/3/15.
//

import Foundation
import UIKit
import ZLBaseExtension

@objc public class ZMUIConfig: NSObject {
    
    // MARK: - 导航栏相关
    @objc public var navigationBarBackgoundColor: UIColor
    @objc public var navigationBarTitleColor: UIColor
    @objc public var navigationBarTitleFont: UIFont
    @objc public var navigationBarHeight: CGFloat
    
    // MARK: - 视图控制器背景
    @objc public var viewControllerBackgoundColor: UIColor
    
    // MARK: - 按钮相关
    @objc public var buttonBorderColor: UIColor
    @objc public var buttonBackColor: UIColor
    @objc public var buttonTitleColor: UIColor
    @objc public var buttonTitleFont: UIFont
    @objc public var buttonCornerRadius: CGFloat
    @objc public var buttonBorderWidth: CGFloat
    
    // MARK: - 单例
    @objc public static let shared = ZMUIConfig()
    
    private override init() {

        navigationBarTitleFont = .systemFont(ofSize: 17)
        navigationBarHeight = 60.0

        buttonTitleFont = .systemFont(ofSize: 15)
        buttonCornerRadius = 0
        buttonBorderWidth = 0

        buttonBorderColor = .clear
        buttonBackColor = .clear
        if #available(iOS 13.0, *) {
            navigationBarBackgoundColor = .secondarySystemBackground
            navigationBarTitleColor = .label
            viewControllerBackgoundColor = .systemBackground
            buttonTitleColor = .label
        } else {
            navigationBarBackgoundColor = .white
            navigationBarTitleColor = .black
            viewControllerBackgoundColor = .white
            buttonTitleColor = .black
        }
        
        super.init()
    }
}


