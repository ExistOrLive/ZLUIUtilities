//
//  ZMViewController.swift
//  ZMMVVM
//
//  Created by 朱猛 on 2024/10/24.
//

import Foundation
import UIKit

public class ZMNavigationController: UINavigationController {

    override open func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(zmInteractivePopGestureRecognizer)
        interactivePopGestureRecognizer?.isEnabled = false
    }

    /**
     * 当不使用系统的返回按钮，右滑手势interactivePopGestureRecognizer将会失效
     * 这里创建UIScreenEdgePanGestureRecognizer 实现右滑 target 和 delegate 均为interactivePopGestureRecognizer.delegate
     **/
    lazy var zmInteractivePopGestureRecognizer: UIScreenEdgePanGestureRecognizer = {
        let recognizer = UIScreenEdgePanGestureRecognizer(
            target: self.interactivePopGestureRecognizer?.delegate,
            action: NSSelectorFromString("handleNavigationTransition:")
        )
        recognizer.edges = .left
        recognizer.delegate = self
        return recognizer
    }()

    public var forbidGestureBack: Bool = false
}

// MARK: - UIGestureRecognizerDelegate
extension ZMNavigationController: UIGestureRecognizerDelegate {

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if forbidGestureBack {
            return false
        }
        return children.count > 1
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

