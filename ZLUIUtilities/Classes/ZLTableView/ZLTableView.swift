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
    func zlScrollViewDidScroll(_ scrollView: UIScrollView)
}

public extension ZLTableContainerViewDelegate {
    func zlLoadNewData() { }
    func zlLoadMoreData() { }
    func zlScrollViewDidScroll(_ scrollView: UIScrollView) { }
}


public class ZLTableContainerView: UIView {
    
    // viewModel
    private var viewData: ZLTableViewData = ZLTableViewData()
    
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
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // 外观模式切换
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if self.traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
                
                for sectionData in viewData.sectionDatas {
                    for cellData in sectionData.cellDatas {
                        cellData.clearCache()
                    }
                    sectionData.sectionFooterViewData?.clearCache()
                    sectionData.sectionHeaderViewData?.clearCache()
                }
                tableView.reloadData()
            }
        }
    }
    
    // view
    public private(set) lazy var tableView: UITableView = {
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
    
    func sectionDataForSection(_ section: Int) -> ZLTableViewSectionDataProtocol? {
        viewData.sectionDataFor(section: section)
    }
    
    func cellDataForIndexPath(_ indexPath: IndexPath) -> ZLTableViewCellDataProtocol? {
        let sectionData = viewData.sectionDataFor(section: indexPath.section)
        return sectionData?.cellDataFor(row: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellDataForIndexPath(indexPath)?.cellHeight ?? UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellDataForIndexPath(indexPath)?.onCellSingleTap()
    }

    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        cellDataForIndexPath(indexPath)?.cellSwipeActions
    }
    
    
    // Section
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        sectionDataForSection(section)?.sectionHeaderViewData?.sectionViewHeight ?? CGFloat.leastNonzeroMagnitude
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        sectionDataForSection(section)?.sectionFooterViewData?.sectionViewHeight ?? CGFloat.leastNonzeroMagnitude
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionData = sectionDataForSection(section),
              let sectionHeaderData = sectionData.sectionHeaderViewData else {
            return nil
        }
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: sectionHeaderData.sectionViewReuseIdentifier)
        sectionHeaderData.numberOfSection = viewData.numberOfSections()
        sectionHeaderData.section = section
        sectionHeaderData.isHeader = true
        if let updatable = view as? ZLViewUpdatable {
            updatable.fillWithData(data: sectionHeaderData)
        }
        return view
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let sectionData = sectionDataForSection(section),
              let sectionFooterData = sectionData.sectionFooterViewData else {
            return nil
        }
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: sectionFooterData.sectionViewReuseIdentifier)
        sectionFooterData.numberOfSection = viewData.numberOfSections()
        sectionFooterData.section = section
        sectionFooterData.isHeader = false
        if let updatable = view as? ZLViewUpdatable {
            updatable.fillWithData(data: sectionFooterData)
        }
        return view
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.zlScrollViewDidScroll(scrollView)
    }
}

// MARK: UITableViewDataSource
extension ZLTableContainerView: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        viewData.numberOfSections()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionDataForSection(section)?.numberOfCellsInSection() ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cellData = cellDataForIndexPath(indexPath),
              let cell = tableView.dequeueReusableCell(withIdentifier: cellData.cellReuseIdentifier) else {
            return UITableViewCell()
        }
        cellData.indexPath = indexPath
        
        if let updatable = cell as? ZLViewUpdatable {
            updatable.fillWithData(data: cellData)
            
            if let cellData = cellData as? ZLViewUpdatableDataModel {
                cellData.setViewUpdatable(updatable)
            }
        }
        
        
        
        return cell
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
    
    func register(_ viewClass: AnyClass?, forViewReuseIdentifier identifier: String) {
        tableView.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func setTableViewHeader() {
        setRefreshView(type: .header)
    }

    func setTableViewFooter() {
        setRefreshView(type: .footer)
        hiddenRefreshView(type: .footer)
    }
    
    
    func resetSectionDatas(sectionDatas: [ZLTableViewSectionDataProtocol], hasMoreData: Bool) {
    
        viewData.sectionDatas = sectionDatas
        
        endRefreshView(type: .header)
        if !hasMoreData {
            endRefreshFooterWithNoMoreData()
        } else {
            resetRefreshFooter()
            endRefreshView(type: .footer)
        }
        
        if viewData.isEmpty {
            hiddenRefreshView(type: .footer)
        } else {
            showRefreshView(type: .footer)
        }
        viewStatus = viewData.isEmpty ? .empty : .normal
        
        tableView.reloadData()
    }
    
    func appendSectionDatas(sectionDatas: [ZLTableViewSectionDataProtocol], hasMoreData: Bool) {
        
        self.viewData.sectionDatas.append(contentsOf: sectionDatas)
        
        if !hasMoreData {
            endRefreshFooterWithNoMoreData()
        } else {
            endRefreshView(type: .footer)
        }
        
        if viewData.isEmpty {
            hiddenRefreshView(type: .footer)
        } else {
            showRefreshView(type: .footer)
        }
        viewStatus = viewData.isEmpty ? .empty : .normal
        
        self.tableView.reloadData()
    }
    
    
    func resetCellDatas(cellDatas: [ZLTableViewCellDataProtocol], hasMoreData: Bool) {
        
        if let sectionData = viewData.sectionDatas.first {
            sectionData.cellDatas = cellDatas
        } else {
           let sectionData = ZLTableViewBaseSectionData()
            sectionData.cellDatas = cellDatas
            viewData.sectionDatas = [sectionData]
        }
        
        endRefreshView(type: .header)
        if !hasMoreData {
            endRefreshFooterWithNoMoreData()
        } else {
            resetRefreshFooter() 
            endRefreshView(type: .footer)
        }
    
        if viewData.isEmpty {
            hiddenRefreshView(type: .footer)
        } else {
            showRefreshView(type: .footer)
        }
        viewStatus = viewData.isEmpty ? .empty : .normal
        
        tableView.reloadData()
    }

    func appendCellDatas(cellDatas: [ZLTableViewCellDataProtocol], hasMoreData: Bool) {
        
        if let sectionData = viewData.sectionDatas.first {
            sectionData.cellDatas.append(contentsOf: cellDatas)
        } else {
            let sectionData = ZLTableViewBaseSectionData()
            sectionData.cellDatas = cellDatas
            viewData.sectionDatas = [sectionData]
        }
        
        if !hasMoreData {
            endRefreshFooterWithNoMoreData()
        } else {
            endRefreshView(type: .footer)
        }
        
            
        if viewData.isEmpty {
            hiddenRefreshView(type: .footer)
        } else {
            showRefreshView(type: .footer)
        }
        viewStatus = viewData.isEmpty ? .empty : .normal
        
        self.tableView.reloadData()
    }

    func resetContentOffset() {
        self.tableView.setContentOffset(CGPoint.zero, animated: false)
    }

    func clearListView() {
        self.viewData = ZLTableViewData()
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
        
        if viewData.numberOfSections() == 0 {
            hiddenRefreshView(type: .footer)
        } else {
            showRefreshView(type: .footer)
        }
        viewStatus = viewData.numberOfSections() == 0 ? .empty : .normal
    }

    func justRefresh() {
        self.justReloadRefreshView()
        self.tableView.reloadData()
    }

    func reloadData() {
        self.tableView.reloadData()
    }
    
    func reloadDataWith(sectionIds: [String], animation: UITableView.RowAnimation = .none) {
        let sectionIndexes = viewData.sectionDatas.enumerated().compactMap { (index, sectionData) in
            if sectionIds.contains(sectionData.sectionId) {
                return index
            }
            return nil
        }
        if !sectionIndexes.isEmpty {
            self.tableView.reloadSections(IndexSet(sectionIndexes), with: animation)
        }
    }
    
    func reloadDataWith(rowIds: [(String,String)], animation: UITableView.RowAnimation = .none) {
        let indexPaths = rowIds.compactMap { (sectionId,rowId) in
            if let sectionIndex = viewData.sectionDatas.firstIndex(where: { $0.sectionId == sectionId }) {
                if let rowIndex = viewData.sectionDatas[sectionIndex].cellDatas.firstIndex(where: { $0.cellId == rowId }) {
                    return IndexPath(row: rowIndex, section: sectionIndex)
                }
            }
            return nil
        }
      
        if !indexPaths.isEmpty {
            self.tableView.reloadRows(at: indexPaths, with: animation)
        }
    }
    
    var tableViewFooter: UIView? {
        get {
            tableView.tableFooterView
        }
        
        set{
            tableView.tableFooterView = newValue
        }
    }
    
    var tableViewHeader: UIView? {
        get {
            tableView.tableHeaderView
        }
        
        set{
            tableView.tableHeaderView = newValue
        }
    }
}
