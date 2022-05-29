//
//  ZLRefreshHeader.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/16.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import MJRefresh

public enum ZLRefreshViewType: Int {
    case header
    case footer
}

public protocol ZLRefreshProtocol: NSObjectProtocol {
    
    var scrollView: UIScrollView { get }
    
    func refreshLoadNewData()
    
    func refreshLoadMoreData()
}

public extension ZLRefreshProtocol {
   
    func setRefreshView(type: ZLRefreshViewType) {
        if type == .footer {
            scrollView.mj_footer = ZLRefresh.refreshFooter { [weak self] in
                self?.refreshLoadMoreData()
            }
        } else if type == .header {
            scrollView.mj_header = ZLRefresh.refreshHeader { [weak self] in
                self?.refreshLoadNewData()
            }
        }
    }
    
    func hiddenRefreshView(type: ZLRefreshViewType) {
        if type == .footer {
            scrollView.mj_footer?.isHidden = true
        } else if type == .header {
            scrollView.mj_header?.isHidden = true
        }
    }
    
    func showRefreshView(type: ZLRefreshViewType) {
        if type == .footer {
            scrollView.mj_footer?.isHidden = false
        } else if type == .header {
            scrollView.mj_header?.isHidden = false
        }
    }
    
    func beginRefreshView(type: ZLRefreshViewType) {
        if type == .footer {
            scrollView.mj_footer?.beginRefreshing()
        } else if type == .header {
            scrollView.mj_header?.beginRefreshing()
        }
    }
    
    func endRefreshView(type: ZLRefreshViewType) {
        if type == .footer {
            scrollView.mj_footer?.endRefreshing()
        } else if type == .header {
            scrollView.mj_header?.endRefreshing()
        }
    }
    
    func endRefreshFooterWithNoMoreData() {
        scrollView.mj_footer?.endRefreshingWithNoMoreData()
    }
    
    func resetRefreshFooter() {
        scrollView.mj_footer?.resetNoMoreData()
    }
    
}


@objcMembers public class ZLRefresh: NSObject {
    
    public static func set(headerIdleTextBlock: @escaping () -> String,
                           headerPullingTextBlock: @escaping () -> String,
                           headerRefreshingTextBlock: @escaping () -> String,
                           autoFooterRefreshingTextBlock: @escaping () -> String,
                           autoFooterNoMoreDataTextBlock: @escaping () -> String) {
        ZLRefresh.MJRefreshHeaderIdleTextBlock = headerIdleTextBlock
        ZLRefresh.MJRefreshHeaderPullingTextBlock = headerPullingTextBlock
        ZLRefresh.MJRefreshHeaderRefreshingTextBlock = headerRefreshingTextBlock
        ZLRefresh.MJRefreshAutoFooterRefreshingTextBlock = autoFooterRefreshingTextBlock
        ZLRefresh.MJRefreshAutoFooterNoMoreDataTextBlock = autoFooterNoMoreDataTextBlock
    }

    static var MJRefreshHeaderIdleTextBlock: (() -> String)?
    
    static var MJRefreshHeaderPullingTextBlock: (() -> String)?
    
    static var MJRefreshHeaderRefreshingTextBlock: (() -> String)?
    
    static var MJRefreshAutoFooterRefreshingTextBlock: (() -> String)?
    
    static var MJRefreshAutoFooterNoMoreDataTextBlock: (() -> String)?
    
    public static func refreshHeader(refreshingBlock:@escaping MJRefreshComponentAction) -> MJRefreshHeader {
        let header = MJRefreshNormalHeader.init(refreshingBlock: refreshingBlock)
        header.lastUpdatedTimeLabel?.isHidden = true
        header.setTitle(ZLRefresh.MJRefreshHeaderIdleTextBlock?() ?? "下拉可以刷新", for: .idle)
        header.setTitle(ZLRefresh.MJRefreshHeaderPullingTextBlock?() ?? "松开立即刷新", for: .pulling)
        header.setTitle(ZLRefresh.MJRefreshHeaderRefreshingTextBlock?() ?? "正在刷新数据中...", for: .refreshing)
        return header
    }

    public static func refreshFooter(refreshingBlock:@escaping MJRefreshComponentAction) -> MJRefreshFooter {
        let footer = MJRefreshAutoStateFooter.init(refreshingBlock: refreshingBlock)
        footer.setTitle("", for: .idle)
        footer.setTitle(ZLRefresh.MJRefreshAutoFooterRefreshingTextBlock?() ?? "正在加载更多的数据...", for: .refreshing)
        footer.setTitle(ZLRefresh.MJRefreshAutoFooterNoMoreDataTextBlock?() ?? "已经全部加载完毕", for: .noMoreData)
        return footer
    }

    public static func justRefreshHeader(header: MJRefreshNormalHeader?) {
        header?.setTitle(ZLRefresh.MJRefreshHeaderIdleTextBlock?() ?? "下拉可以刷新", for: .idle)
        header?.setTitle(ZLRefresh.MJRefreshHeaderPullingTextBlock?() ?? "松开立即刷新", for: .pulling)
        header?.setTitle(ZLRefresh.MJRefreshHeaderRefreshingTextBlock?() ?? "正在刷新数据中...", for: .refreshing)
    }

    public static func justRefreshFooter(footer: MJRefreshAutoStateFooter?) {
        footer?.setTitle("", for: .idle)
        footer?.setTitle(ZLRefresh.MJRefreshAutoFooterRefreshingTextBlock?() ?? "正在加载更多的数据...", for: .refreshing)
        footer?.setTitle(ZLRefresh.MJRefreshAutoFooterNoMoreDataTextBlock?() ?? "已经全部加载完毕", for: .noMoreData)
    }

}
