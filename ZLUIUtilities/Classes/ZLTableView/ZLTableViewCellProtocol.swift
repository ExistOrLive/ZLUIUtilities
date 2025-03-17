//
//  ZLTableViewCellDataProtocol.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/15.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import UIKit

// 为避免协议中的方法失去动态性，请勿在非final class的extension中实现协议或在协议扩展中提供默认实现

// MARK: - ZLTableViewDataProtocol UITableView Data
public protocol ZLTableViewDataProtocol: AnyObject {
    
    var viewId: String { get }
    
    var sectionDatas: [ZLTableViewSectionDataProtocol] { get set }
    
    var isEmpty: Bool { get }
    
    func sectionDataFor(section: Int) -> ZLTableViewSectionDataProtocol?
     
    func numberOfSections() -> Int 

}


// MARK: - ZLTableViewSectionViewDataProtocol UITableView SectionFooter/SectionHeader Data
public protocol ZLTableViewSectionViewDataProtocol: AnyObject {
    
    var sectionViewId: String { get }
    
    var sectionViewHeight: CGFloat { get }
    
    var sectionViewReuseIdentifier: String { get }
    
    var isHeader: Bool { get set }
    
    var section: Int { get set }
    
    var numberOfSection: Int { get set }
    
    func clearCache() 

}

// MARK: - ZLTableViewSectionProtocol UITableView Section Data
public protocol ZLTableViewSectionDataProtocol: AnyObject {
    
    var sectionId: String { get }
    
    var cellDatas: [ZLTableViewCellDataProtocol] { get  set }
    
    var sectionHeaderViewData: ZLTableViewSectionViewDataProtocol? { get }
    
    var sectionFooterViewData: ZLTableViewSectionViewDataProtocol? { get }
    
    var isEmpty: Bool { get }
    
    func cellDataFor(row: Int) -> ZLTableViewCellDataProtocol?
     
    func numberOfCellsInSection() -> Int
}

// MARK: - ZLTableViewCellDataProtocol UITableView CellData
public protocol ZLTableViewCellDataProtocol: AnyObject {
    
    var cellId: String { get }
    
    var cellReuseIdentifier: String { get }
    
    var cellHeight: CGFloat { get }
    
    var indexPath: IndexPath? { get set }
    
    var numberOfSection: Int? { get set }
    
    var numberOfRowInCurrentSection: Int? { get set }
    
    var cellSwipeActions: UISwipeActionsConfiguration? { get }
    
    func onCellSingleTap()
    
    func clearCache()
}

