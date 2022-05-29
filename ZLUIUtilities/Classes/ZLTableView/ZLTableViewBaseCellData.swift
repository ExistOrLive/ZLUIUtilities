//
//  ZLTableViewBaseCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/15.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import ZLBaseUI

open class ZLTableViewBaseCellData: ZLBaseViewModel,ZLTableViewCellProtocol {
   
    public var indexPath: IndexPath?
    
    open var cellReuseIdentifier: String {
        "UITableViewCell"
    }
    
    open var cellHeight: CGFloat {
        UITableView.automaticDimension
    }
    
    open var cellSwipeActions: UISwipeActionsConfiguration? {
        nil
    }
    
    open func onCellSingleTap() {
        
    }
    
    open func setCellIndexPath(indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
    open func clearCache() {
        
    }
}

open class ZLTableViewBaseSectionData: ZLBaseViewModel,ZLTableViewSectionProtocol {
    
    private var _cellDatas: [ZLTableViewCellProtocol]
    
    public init(cellDatas: [ZLTableViewCellProtocol]) {
        self._cellDatas = cellDatas
        super.init()
    }
    
    open var cellDatas: [ZLTableViewCellProtocol] {
        _cellDatas
    }
    
    open var sectionHeaderHeight: CGFloat {
        CGFloat.leastNonzeroMagnitude
    }
    
    open var sectionFooterHeight: CGFloat {
        CGFloat.leastNonzeroMagnitude
    }
    
    open  var sectionHeaderReuseIdentifier: String? {
        nil
    }
    
    open var sectionFooterReuseIdentifier: String? {
        nil
    }
    
    open func resetCellDatas(cellDatas: [ZLTableViewCellProtocol]) {
        _cellDatas = cellDatas
    }

    open func appendCellDatas(cellDatas: [ZLTableViewCellProtocol]) {
        _cellDatas.append(contentsOf: cellDatas)
    }
    
    open override func removeFromSuperViewModel() {
        for cellData in cellDatas {
            if let viewModel = cellData as? ZLBaseViewModel {
                viewModel.removeFromSuperViewModel()
            }
        }
        super.removeFromSuperViewModel()
    }
    
}






