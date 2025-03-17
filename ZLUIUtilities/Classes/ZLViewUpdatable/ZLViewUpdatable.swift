//
//  ZLViewUpdate.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/3/30.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import UIKit

// MARK: ZLViewUpdatable
public protocol ZLViewUpdatable: AnyObject {
        
    func fillWithData(data: Any)
    
    func justUpdateView()
}

// MARK: ZLViewUpdatableForView
public protocol ZLViewUpdatableWithViewData: ZLViewUpdatable {
    
    associatedtype ViewData
    
    func fillWithViewData(viewData: ViewData)
}

public extension ZLViewUpdatableWithViewData where Self: UIView {
    func fillWithData(data: Any) {
        if let viewData = data as? ViewData {
            fillWithViewData(viewData: viewData)
        }
    }
}
