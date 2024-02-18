//
//  ZLTableViewBaseCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/15.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import ZLBaseUI

// MARK: - ZLTableViewBaseCellData
open class ZLTableViewBaseCellData: ZLBaseViewModel,ZLTableViewCellDataProtocol {
    
    open var cellId: String = ""
    
    open var cellReuseIdentifier: String = "UITableViewCell"
    
    open var cellHeight: CGFloat = UITableView.automaticDimension
    
    open var indexPath: IndexPath? = nil
    
    open var numberOfSection: Int? = nil
    
    open var numberOfRowInCurrentSection: Int? = nil
    
    open var cellSwipeActions: UISwipeActionsConfiguration? { nil }
    
    open func onCellSingleTap() { }

    open func clearCache() { }
}

// MARK: - ZLTableViewBaseSectionViewData
open class ZLTableViewBaseSectionViewData: ZLBaseViewModel,ZLTableViewSectionViewDataProtocol {
    
    open var sectionViewId: String = ""
    
    open var sectionViewHeight: CGFloat = UITableView.automaticDimension
    
    open var sectionViewReuseIdentifier: String = ""
    
    open var isHeader: Bool = false
    
    open var section: Int = 0
     
    open var numberOfSection: Int = 0
    
    open func clearCache() { }
}


// MARK: - ZLTableViewBaseSectionData
open class ZLTableViewBaseSectionData: ZLBaseViewModel,ZLTableViewSectionDataProtocol {
    
    public init(cellDatas: [ZLTableViewCellDataProtocol] = []) {
        self.cellDatas = cellDatas
        super.init()
    }
    
    open var sectionId: String = ""
    
    open var cellDatas: [ZLTableViewCellDataProtocol] = []
    
    open var sectionHeaderViewData: ZLTableViewSectionViewDataProtocol? = nil
    
    open var sectionFooterViewData: ZLTableViewSectionViewDataProtocol? = nil
    
    open var isEmpty: Bool { cellDatas.isEmpty }
    
    open func cellDataFor(row: Int) -> ZLTableViewCellDataProtocol? {
        if row < cellDatas.count {
            return cellDatas[row]
        } else {
            return nil
        }
    }
    
    open func numberOfCellsInSection() -> Int {
        cellDatas.count
    }
}

// MARK: - ZLTableViewData
open class ZLTableViewData: ZLBaseViewModel,ZLTableViewDataProtocol {
   
    public var viewId: String = ""
    
    public var sectionDatas: [ZLTableViewSectionDataProtocol] = []
    
    open var isEmpty: Bool { sectionDatas.isEmpty || (sectionDatas.count == 1 && sectionDatas[0].isEmpty ) }
    
    open func sectionDataFor(section: Int) -> ZLTableViewSectionDataProtocol? {
        if section < sectionDatas.count {
            return sectionDatas[section]
        } else {
            return nil
        }
    }
    
    open func numberOfSections() -> Int {
        sectionDatas.count
    }
}






