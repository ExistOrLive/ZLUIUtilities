//
//  ZLTableView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/15.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import MJRefresh
import ZLBaseUI
import ZLBaseExtension
import UIKit
import SnapKit

public protocol ZLTableContainerViewDelegate: AnyObject {
    func zlLoadNewData()
    func zlLoadMoreData()
}


public class ZLTableContainerView: UIView {
    
    // viewModel
    private var sectionDatas: [ZLTableViewSectionProtocol] = []
    
    private var style: UITableView.Style = .grouped
    
    public weak var delegate: ZLTableContainerViewDelegate?
    
    public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame)
        self.style = style
        setUpUI()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        backgroundColor = .clear
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public override func tintColorDidChange() {
        // appearence mode 改变
        for sectionData in sectionDatas {
            for cellData in sectionData.cellDatas {
                cellData.clearCache()
            }
        }
        tableView.reloadData()
    }

    // view
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: self.bounds, style: self.style)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        return tableView
    }()
}

// MARK: UITableViewDelegate
extension ZLTableContainerView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        sectionDatas[indexPath.section].cellDatas[indexPath.row].cellHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableViewCellData = sectionDatas[indexPath.section].cellDatas[indexPath.row]
        tableViewCellData.onCellSingleTap()
    }

    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let tableViewCellData = sectionDatas[indexPath.section].cellDatas[indexPath.row]
        return tableViewCellData.cellSwipeActions
    }
    
    
    // Section
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        sectionDatas[section].sectionHeaderHeight
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        sectionDatas[section].sectionFooterHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let reuseIdentifier = sectionDatas[section].sectionHeaderReuseIdentifier {
           return tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier)
        }
        return nil
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let reuseIdentifier = sectionDatas[section].sectionFooterReuseIdentifier {
           return tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier)
        }
        return nil
    }
}

// MARK: UITableViewDataSource
extension ZLTableContainerView: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionDatas.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionDatas[section].cellDatas.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let tableViewCellData = sectionDatas[indexPath.section].cellDatas[indexPath.row]
        tableViewCellData.setCellIndexPath(indexPath: indexPath)

        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: tableViewCellData.cellReuseIdentifier, for: indexPath)

        if let updatable = tableViewCell as? ZLViewUpdatable {
            updatable.fillWithData(data: tableViewCellData)
        }
        return tableViewCell
    }
  
}

// MARK: ZLRefreshProtocol
extension ZLTableContainerView: ZLRefreshProtocol {
    
    public var scrollView: UIScrollView {
        tableView
    }
    
    public func refreshLoadNewData() {
        delegate?.zlLoadNewData()
    }
    
    public func refreshLoadMoreData() {
        delegate?.zlLoadMoreData()
    }
}

// MARK: ZLViewStatus
extension ZLTableContainerView: ZLViewStatusProtocol {
    public var targetView: UIView {
        tableView
    }
}


// MARK: Outer Method
public extension ZLTableContainerView {
    
    func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        tableView.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func setTableViewHeader() {
        setRefreshView(type: .header)
    }

    func setTableViewFooter() {
        setRefreshView(type: .footer)
        hiddenRefreshView(type: .footer)
    }
    
    func resetCellDatas(cellDatas: [ZLTableViewCellProtocol], hasMoreData: Bool) {
        if !cellDatas.isEmpty {
            sectionDatas = [ZLTableViewBaseSectionData(cellDatas: cellDatas)]
        } else {
            sectionDatas = []
        }
        
        endRefreshView(type: .header)
        if !hasMoreData {
            endRefreshFooterWithNoMoreData()
        } else {
            resetRefreshFooter() 
            endRefreshView(type: .footer)
        }
    
        if sectionDatas.isEmpty {
            hiddenRefreshView(type: .footer)
        } else {
            showRefreshView(type: .footer)
        }
        viewStatus = sectionDatas.isEmpty ? .empty : .normal
        
        tableView.reloadData()
    }

    func appendCellDatas(cellDatas: [ZLTableViewCellProtocol], hasMoreData: Bool) {
        
        if let section = sectionDatas.first {
            section.appendCellDatas(cellDatas: cellDatas)
        } else {
            sectionDatas = [ZLTableViewBaseSectionData(cellDatas: cellDatas)]
        }
        
        if !hasMoreData {
            endRefreshFooterWithNoMoreData()
        } else {
            endRefreshView(type: .footer)
        }
        
            
        if sectionDatas.isEmpty {
            hiddenRefreshView(type: .footer)
        } else {
            showRefreshView(type: .footer)
        }
        viewStatus = sectionDatas.isEmpty ? .empty : .normal
        
        self.tableView.reloadData()
    }

    func resetContentOffset() {
        self.tableView.setContentOffset(CGPoint.zero, animated: false)
    }

    func clearListView() {
        self.sectionDatas.removeAll()
        self.tableView.reloadData()
    }

    func startLoad() {
        viewStatus = .loading
        delegate?.zlLoadNewData()
    }
    
    func beginRefresh() {
        beginRefreshView(type: .header)
    }

    func endRefresh() {
        endRefreshView(type: .header)
        endRefreshView(type: .footer)
        
        if sectionDatas.isEmpty {
            hiddenRefreshView(type: .footer)
        } else {
            showRefreshView(type: .footer)
        }
        viewStatus = sectionDatas.isEmpty ? .empty : .normal
    }

    func justRefresh() {
        ZLRefresh.justRefreshHeader(header: self.tableView.mj_header as? MJRefreshNormalHeader)
        ZLRefresh.justRefreshFooter(footer: self.tableView.mj_footer as? MJRefreshAutoStateFooter)
        self.tableView.reloadData()
    }

    func reloadData() {
        self.tableView.reloadData()
    }
    
}
