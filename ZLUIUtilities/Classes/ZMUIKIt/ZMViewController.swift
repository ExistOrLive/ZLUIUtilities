//
//  ZMViewController.swift
//  ZMMVVM
//
//  Created by 朱猛 on 2025/3/15.
//

import Foundation
import UIKit
import ZMMVVM
import SnapKit

open class ZMViewController: ZMBaseViewController, ZLViewStatusProtocol {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    open override var title: String? {
        didSet {
            super.title = title
            zmNavigationBar.titleLabel.text = title
        }
    }
    
    open var isZmNavigationBarHidden: Bool {
        get {
            return zmNavigationBar.isHidden
        }
        set {
            zmNavigationBar.isHidden = newValue
        }
    }
    
    // MARK: Life Cycle
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: setupUI
    open func setupUI() {
        view.backgroundColor = ZMUIConfig.shared.viewControllerBackgoundColor

        view.addSubview(viewStackView)
        viewStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if navigationController == nil {
            isZmNavigationBarHidden = true
        } else {
            isZmNavigationBarHidden = false
            zmNavigationBar.backButton.isHidden = navigationController?.viewControllers.first == self
        }
    }
    
    // MARK: UI
    public lazy var viewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.addArrangedSubview(zmNavigationBar)
        stackView.addArrangedSubview(contentView)
        return stackView
    }()
    
    public lazy var zmNavigationBar: ZMNavigationBar = {
        let bar = ZMNavigationBar()
        bar.backButton.addTarget(self, action: #selector(onBackButtonClicked(_ :)), for: .touchUpInside)
        return bar
    }() 

    public lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: Action
    @objc open func onBackButtonClicked(_ button: UIButton) {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}
