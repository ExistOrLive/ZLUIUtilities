//
//  ZMNavigationBar.swift
//  ZMMVVM
//
//  Created by 朱猛 on 2025/3/15.
//
import Foundation
import UIKit
import SnapKit

public class ZMNavigationBar: UIView {

    // MARK: - UI Components
    public lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "back_Common"), for: .normal)
        return button
    }()

    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ZMUIConfig.shared.navigationBarTitleColor
        label.font = ZMUIConfig.shared.navigationBarTitleFont
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        return label
    }()
    
    public lazy var rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    public lazy var barContainer: UIView = {
        let view = UIView()
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(rightStackView)
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(80)
            make.right.equalToSuperview().offset(-80)
        }
        
        rightStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        return view
    }()
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

  
    // MARK: - UI Setup
    open func setupUI() {
        backgroundColor = ZMUIConfig.shared.navigationBarBackgoundColor
        layer.shadowRadius = 0.3
        
        addSubview(barContainer)
        barContainer.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(ZMUIConfig.shared.navigationBarHeight)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
    }
    
    // MARK: - Public Methods
    
    public func addRightView(_ view: UIView) {
        rightStackView.addArrangedSubview(view)
    }
    
    public func removeAllRightViews() {
        rightStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
