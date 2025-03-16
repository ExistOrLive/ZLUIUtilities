//
//  ZMUIConfig.swift
//  ZLUIUtilities
//
//  Created by 朱猛 on 2025/3/15.
//

import Foundation
import UIKit
import ZLBaseExtension

public class ZMUIConfig: NSObject {
    
    // MARK: - 导航栏相关
    public var navigationBarBackgoundColor: UIColor
    public var navigationBarTitleColor: UIColor
    public var navigationBarTitleFont: UIFont
    public var navigationBarHeight: CGFloat
    
    // MARK: - 视图控制器背景
    public var viewControllerBackgoundColor: UIColor
    
    // MARK: - 按钮相关
    public var buttonBorderColor: UIColor
    public var buttonBackColor: UIColor
    public var buttonTitleColor: UIColor
    public var buttonTitleFont: UIFont
    public var buttonCornerRadius: CGFloat
    public var buttonBorderWidth: CGFloat
    
    // MARK: - 单例
    public static let shared = ZMUIConfig()
    
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


