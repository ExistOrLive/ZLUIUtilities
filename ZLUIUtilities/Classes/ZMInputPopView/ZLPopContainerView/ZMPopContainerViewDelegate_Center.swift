//
//  ZMPopContainerViewPopDelegate.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2023/2/22.
//  Copyright © 2023 ZM. All rights reserved.
//

import Foundation
import UIKit
import ZLUtilities

public var ZLScreenBoundsAdjustWithScreenOrientation: CGRect {
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    if (UIDevice.current.orientation.isPortrait && width <= height) ||
        (UIDevice.current.orientation.isLandscape && width > height) {
        return CGRect(origin: .zero, size: CGSize(width: width, height: height))
    } else if (UIDevice.current.orientation.isPortrait && width > height) ||
                (UIDevice.current.orientation.isLandscape && width <= height) {
        return CGRect(origin: .zero, size: CGSize(width: height, height: width))
    }
    return UIScreen.main.bounds
}


public class ZMPopContainerViewDelegate_Center: NSObject, ZMPopContainerViewDelegate {
    
    public static let shared = ZMPopContainerViewDelegate_Center()
    
    public func popContainerViewShouldChangeFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> Bool {
        ZLDeviceInfo.isIpad()
    }
    
    public func popContainerViewShouldChangeContentViewFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> Bool {
        ZLDeviceInfo.isIpad()
    }
    
    public func popContainerViewChangeFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> CGRect {
        return ZLScreenBoundsAdjustWithScreenOrientation
    }
    
    public func popContainerViewChangeContentViewTargetFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> CGRect {
        guard let contentView = view.content else {
            return .zero
        }
        let origin = CGPoint(x: (view.frame.width - contentView.frame.width) / 2,
                             y: (view.frame.height - contentView.frame.height) / 2)
        return CGRect(origin: origin, size: contentView.frame.size)
    }
    
    public func popContainerViewChangeContentViewInitFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> CGRect {
        let origin = CGPoint(x: view.frame.width / 2 , y: view.frame.height / 2 )
        return CGRect(origin: origin, size: .zero)
    }
    
}
