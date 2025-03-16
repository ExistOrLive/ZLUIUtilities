//
//  ZLViewStatus.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/3/27.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import UIKit
import ZLBaseExtension

@objc public enum ZLViewStatus: Int {
    case loading = 0
    case normal
    case error
    case empty
}

// MARK: ZLViewStatusProtocol
public protocol ZLViewStatusProtocol: AnyObject {
    
    var targetView: UIView { get }
    var viewStatus: ZLViewStatus { get set }
}

private var viewStatusContext: UInt8 = 0
private var tipViewContext: UInt8 = 0
private var progressViewContext: UInt8 = 0

// MARK: ZLViewStatusProtocol + UIView
public extension ZLViewStatusProtocol where Self: UIView {
    var targetView: UIView { self }
}

// MARK: ZLViewStatusProtocol + UIViewController
public extension ZLViewStatusProtocol where Self: UIViewController {
    var targetView: UIView { self.view }
}

// MARK: ZLViewStatusProtocol + ZMViewController
public extension ZLViewStatusProtocol where Self: ZMViewController {
    var targetView: UIView { self.contentView }
}

// MARK: ZLViewStatusProtocol + ZM
public extension ZLViewStatusProtocol where Self: ZMTableViewController {
    var targetView: UIView { self.tableView }
}


// MARK: ZLViewStatusProtocol Extension
public extension ZLViewStatusProtocol {

    var viewStatus: ZLViewStatus {
        set{
            objc_setAssociatedObject(self, &viewStatusContext, newValue, .OBJC_ASSOCIATION_ASSIGN)
            switch newValue {
            case .normal:
                hideTipView()
                hideProgressView()
            case .empty:
                hideProgressView()
                showTipView()
            case .loading:
                hideTipView()
                showProgressView()
            case .error:
                hideProgressView()
                showTipView()
            }
        }
        get{
            guard let value = objc_getAssociatedObject(self, &viewStatusContext) as? ZLViewStatus else {
                return .normal
            }
            return value
        }
    }
    
   var tipView: ZLViewStatusTipView {
        guard let tipView = objc_getAssociatedObject(self, &tipViewContext) as? ZLViewStatusTipView else {
            let tipView = ZLViewStatusTipView()
            objc_setAssociatedObject(self, &tipViewContext, tipView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return tipView
        }
        return tipView
    }
    
    var progressView: ZLViewStatusProgressView {
        guard let progressView = objc_getAssociatedObject(self, &progressViewContext) as? ZLViewStatusProgressView else {
            let progressView = ZLViewStatusProgressView()
            objc_setAssociatedObject(self, &progressViewContext, progressView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return progressView
        }
        return progressView
    }
    
    func showTipView() {
        if tipView.superview == nil {
            targetView.addSubview(tipView)
            tipView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.size.equalToSuperview()
            }
        }
        targetView.bringSubviewToFront(tipView)
    }
    
    func hideTipView() {
        tipView.removeFromSuperview()
    }
    
    func showProgressView() {
        if let scrollView = targetView as? UIScrollView {
            
            if progressView.superview == nil{
                scrollView.addSubview(progressView)
                progressView.snp.makeConstraints { make in
                    make.edges.equalTo(scrollView.frameLayoutGuide)
                }
            }
            progressView.showProgressView()
            scrollView.bringSubviewToFront(progressView)
            
        } else {
            
            if progressView.superview == nil {
                targetView.addSubview(progressView)
                progressView.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                    make.size.equalToSuperview()
                }
            }
            progressView.showProgressView()
            targetView.bringSubviewToFront(progressView)
        }
        
    }
    
    func hideProgressView() {
        progressView.hiddenProgressView()
        progressView.removeFromSuperview()
    }
    
}


@objcMembers public class ZLViewStatusPresenter: NSObject {
    
    public static func set(noDataImageBlock: @escaping () -> UIImage ) {
        ZLViewStatusPresenter.NoDataImageBlock = noDataImageBlock
    }

    static var NoDataImageBlock: (() -> UIImage)?
}


