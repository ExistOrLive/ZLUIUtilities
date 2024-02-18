//
//  ZLBubbleButtonView.swift
//  ZLUIUtilities
//
//  Created by 朱猛 on 2024/2/18.
//

import Foundation
import ZLBaseExtension


public protocol ZLBubbleButtonViewItemProtocol {
    var bubbleButtonTitle: String { get }
    var bubbleButtonTitleColor: UIColor { get }
    var bubbleButtonTitleFont: UIFont { get }
    var bubbleButtonAttributedTitle: NSAttributedString? { get }
    var bubbleButtonBackgroundColor: UIColor { get }
}


public extension ZLBubbleButtonViewItemProtocol {
    var bubbleButtonTitleColor: UIColor {
        return .black
    }
    var bubbleButtonTitleFont: UIFont {
        return .zlMediumFont(withSize: 12)
    }
    var bubbleButtonAttributedTitle: NSAttributedString? {
        nil
    }
    var bubbleButtonBackgroundColor: UIColor {
        .clear
    }
}


extension String: ZLBubbleButtonViewItemProtocol {
    public var bubbleButtonTitle: String {
        return self
    }
}




public class ZLBubbleButtonView: ZLBubbleBaseView {

    public dynamic var clickBlock: ((Int, ZLBubbleButtonViewItemProtocol) -> Void)?

    /// 按钮尺寸
    @objc public dynamic var buttonSize: CGSize = .zero

    /// 气泡按钮
    public dynamic var bubbleButtonViewItems: [ZLBubbleButtonViewItemProtocol] = []


    public override init() {
        super.init()
        contentView.addSubview(buttonStackView)
        setDefaultConfig()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc dynamic public func setDefaultConfig() {
        bubbleImageView.layer.shadowOpacity = 0.2
        bubbleImageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        bubbleBackColor = .white
        bubbleInset = .zero
        trianglePeakOffsetToBorder = 10
        buttonSize = CGSize(width: 72, height: 32)
    }


    @objc dynamic public override func caculateContentSize() -> CGSize {

        if bubbleContentSize != .zero {
            /// 如果设置了 bubbleContentSize 直接使用
            return bubbleContentSize
        }

        return CGSize(width: buttonSize.width,
                      height: buttonSize.height * CGFloat(bubbleButtonViewItems.count))
    }

    @objc dynamic public override func renderData() {
        super.renderData()
        for subView in buttonStackView.subviews {
            subView.removeFromSuperview()
        }
        bubbleButtonViewItems.enumerated().forEach { index,item in
            let button = UIButton(type: .custom)
            if let attributedTitle = item.bubbleButtonAttributedTitle {
                button.setAttributedTitle(attributedTitle, for: .normal)
            } else {
                button.setTitle(item.bubbleButtonTitle, for: .normal)
                button.setTitleColor(item.bubbleButtonTitleColor, for: .normal)
                button.titleLabel?.font = item.bubbleButtonTitleFont
            }
            button.setBackgroundImage(UIImage(color: item.bubbleButtonBackgroundColor), for: .normal)
            button.snp.makeConstraints { make in
                make.size.equalTo(buttonSize)
            }
            button.tag = index
            button.addTarget(self, action: #selector(onButtonClicked(button:)), for: .touchUpInside)
            buttonStackView.addArrangedSubview(button)
        }
    }

    @objc dynamic public override func setLayout(_ view: UIView) {
        super.setLayout(view)
        buttonStackView.frame = contentView.bounds
    }

    @objc dynamic func onButtonClicked(button: UIButton) {
        defer {
            removeBubbleView()
        }
        clickBlock?(button.tag, bubbleButtonViewItems[button.tag])
    }

    @objc dynamic public override func bubble_hitTest(view: UIView?) -> UIView? {

        var res = view
        if let view = view {
            if view == self || view.isDescendant(of: self) {
                if view.isKind(of: UIButton.self) {
                    /// 点击了按钮，气泡不自动消失
                    return view
                }
            } else if view == self {
                /// 点击了背景部分
                if enableUnderlyingViewInteraction {
                    /// 如果允许底层view交互， res 设置为 nil
                    res = nil
                }
            }
        }
        /// 自动消失
        if autoDismiss {
            DispatchQueue.main.async {
                self.removeBubbleView()
            }
        }
        return res
    }

    @objc dynamic public lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
}
