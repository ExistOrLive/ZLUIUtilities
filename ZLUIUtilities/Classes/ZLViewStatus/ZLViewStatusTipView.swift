//
//  ZLViewStatusTipView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/14.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import ZLBaseExtension
import MBProgressHUD

@objc public class ZLViewStatusTipView: UIView {
    
    @objc override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(named: "ZLVCBackColor")
        addSubview(containerView)
        containerView.addSubview(tagImageView)
        containerView.addSubview(descLabel)
        
        tagImageView.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize.init(width: 70, height: 60))
            make.top.left.right.equalToSuperview()
        })
        
        descLabel.snp.makeConstraints({(make) in
            make.top.equalTo(tagImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        })
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private lazy var tagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .center
        imageView.image = ZLViewStatusPresenter.NoDataImageBlock?()
        return imageView
    }()
    
    private lazy var descLabel: UILabel = {
        let label = UILabel.init()
        label.text = "No Data"
        label.textColor = ZLRGBValue_H(colorValue: 0x999999)
        label.font = .zlSemiBoldFont(withSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
}
