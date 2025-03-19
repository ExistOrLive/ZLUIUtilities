//
//  ZMTableViewController.swift
//  ZLUIUtilities
//
//  Created by 朱猛 on 2025/3/15.
//

import Foundation
import ZMMVVM
import UIKit

open class ZMTableViewController: ZMViewController, ZMBaseTableViewContainerProtocol, ZLRefreshProtocol {
    
    public let tableViewProxy: ZMBaseTableViewProxy
    
    public init(style: UITableView.Style = .grouped) {
        self.tableViewProxy = ZMBaseTableViewProxy(style: style)
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func setupUI() {
        super.setupUI()
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // 外观模式切换
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if self.traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
                
                for sectionData in sectionDataArray {
                    for cellData in sectionData.cellDatas {
                        cellData.zm_clearCache()
                    }
                    sectionData.headerData?.zm_clearCache()
                    sectionData.footerData?.zm_clearCache()
                }
                tableView.reloadData()
            }
        }
    }
    
    
    // MARK: ZLRefreshProtocol
    open var scrollView: UIScrollView {
        tableView
    }
    
    open func refreshLoadNewData() {
        
    }
    
    open func refreshLoadMoreData() {
        
    }
    
    // MARK: ViewStatus
    open override var targetView: UIView {
        tableView
    }
}
