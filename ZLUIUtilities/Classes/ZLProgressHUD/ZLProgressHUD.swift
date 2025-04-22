//
//  ZLProgressHUD.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/3/27.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import MBProgressHUD

@objcMembers public class ZLProgressHUD: NSObject {
    
    public class func show() {
        self.show(view: nil, animated: true)
    }
    
    public class func dismiss() {
        self.dismiss(view: nil, animated: true)
    }
    
    @discardableResult
    public class func show(view: UIView?, animated: Bool) -> MBProgressHUD? {
        if let view = view {
           return MBProgressHUD.showAdded(to: view, animated: animated)
        } else {
            if let window = UIApplication.shared.keyWindow {
                return MBProgressHUD.showAdded(to: window, animated: animated)
            }
        }
        return nil
    }
    
    public class func dismiss(view: UIView?, animated: Bool) {
        if let view = view {
            MBProgressHUD.hide(for: view, animated: animated)
        } else {
            if let window = UIApplication.shared.keyWindow {
                MBProgressHUD.hide(for: window, animated: animated)
            }
        }
    }

    public class func dismiss(hud: MBProgressHUD?, animated: Bool) {
        hud?.removeFromSuperViewOnHide = true
        hud?.hide(animated: animated)
    }
}

// MARK: ProgressHUD

public extension UIView {
    
    func showProgressHUD() {
        ZLProgressHUD.show(view: self, animated: true)
    }
    
    func dismissProgressHUD() {
        ZLProgressHUD.dismiss(view: self, animated: true)
    }
}
