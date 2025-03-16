//
//  ZMButton.swift
//  ZLUIUtilities
//
//  Created by 朱猛 on 2025/3/15.
//

import Foundation
import UIKit

open class ZMButton: UIButton {
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        // setUpUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    open func setUpUI() {
        layer.borderColor =  ZMUIConfig.shared.buttonBorderColor.cgColor
        layer.borderWidth =  ZMUIConfig.shared.buttonBorderWidth
        layer.cornerRadius =  ZMUIConfig.shared.buttonCornerRadius
        backgroundColor =  ZMUIConfig.shared.buttonBackColor
        
        titleLabel?.textColor =  ZMUIConfig.shared.buttonTitleColor
        setTitleColor( ZMUIConfig.shared.buttonTitleColor, for: .normal)
        setTitleColor( ZMUIConfig.shared.buttonTitleColor, for: .selected)
    }
    
    
    /// 系统外观发生变化时调用（例如切换暗黑模式）
    /// - Parameter previousTraitCollection: 变化前的特征集合
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
                layer.borderColor =  ZMUIConfig.shared.buttonBorderColor.cgColor
                
                titleLabel?.textColor =  ZMUIConfig.shared.buttonTitleColor
                setTitleColor( ZMUIConfig.shared.buttonTitleColor, for: .normal)
                setTitleColor( ZMUIConfig.shared.buttonTitleColor, for: .selected)
            }
        }
    }
}
