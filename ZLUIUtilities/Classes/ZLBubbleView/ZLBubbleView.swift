//
//  ZLBubbleView.swift
//  Alamofire
//
//  Created by 朱猛 on 2024/2/18.
//

import Foundation
import ZLBaseExtension

public class DuTBubbleView: ZLBubbleBaseView {

    @objc public dynamic var maxBubbleWidth: CGFloat = 132

    /// content
    @objc public dynamic var text: String = ""

    @objc public dynamic var font: UIFont = UIFont.zlRegularFont(withSize: 12)

    @objc public dynamic var textColor: UIColor = .white

    @objc public dynamic var attributedString: NSAttributedString?



    public override init() {
        super.init()
        contentView.addSubview(label)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc dynamic public override func caculateContentSize() -> CGSize {

        if bubbleContentSize != .zero {
            /// 如果设置了 bubbleContentSize 直接使用
            return bubbleContentSize
        }

        /// 计算文本文本大小
        var labelSize: CGSize = .zero
        var attributedBubbleText = NSAttributedString(string: text, attributes: [.font: font])
        if let attributedString = self.attributedString {
            attributedBubbleText = attributedString
        }
        let labelFrame = attributedBubbleText.boundingRect(with: CGSize(width: maxBubbleWidth - bubbleInset.left - bubbleInset.right,
                                                                        height: CGFloat.greatestFiniteMagnitude),
                                                           options: [.usesLineFragmentOrigin,.usesFontLeading],
                                                           context: nil)

        labelSize = CGSize(width: ceil(labelFrame.size.width), height: ceil(labelFrame.size.height))

        return labelSize
    }

    @objc dynamic public override func renderData() {
        super.renderData()
        if let attributedString = self.attributedString {
            label.attributedText = attributedString
        } else {
            label.attributedText = NSAttributedString(string: text, attributes: [.font: font,
                                                                                 .foregroundColor: textColor])
        }
    }

    @objc dynamic open override func setLayout(_ view: UIView) {
        super.setLayout(view)
        label.frame = contentView.bounds
    }



    @objc dynamic public lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
}
