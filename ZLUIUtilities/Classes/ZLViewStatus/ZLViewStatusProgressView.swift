//
//  ZLViewStatusProgressView.swift
//  ZLUIUtilities
//
//  Created by 朱猛 on 2022/6/12.
//

import Foundation
import ZLBaseExtension
import MBProgressHUD

@objc public class ZLViewStatusProgressView: UIView {
    
    @objc override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        showProgressView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showProgressView() {
        if !subviews.contains(where: { view in
            view is MBProgressHUD
        }) {
            ZLProgressHUD.show(view: self, animated: false)
        }
    }
    
    func hiddenProgressView() {
        ZLProgressHUD.dismiss(view: self, animated: false)
        let subViews = self.subviews
        for subView in subViews {
            if let progressHUD = subView as? MBProgressHUD {
                progressHUD.removeFromSuperview()
            }
        }
    }
    
    private func setupUI() {
        backgroundColor = UIColor(named: "ZLVCBackColor")
    }
}

