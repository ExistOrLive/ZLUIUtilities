//
//  ZLBubbleBaseView.swift
//  Alamofire
//
//  Created by 朱猛 on 2024/2/18.
//

import Foundation
import ZLBaseExtension
import UIKit

/// 气泡箭头位置
@objc public enum ZLBubbleViewTrianglePosition: Int {
    case topBorder_leftAlign
    case topBorder_rightAlign
    case bottomBorder_leftAlign
    case bottomBorder_rightAlign
    case leftBorder_topAlign
    case leftBorder_bottomAlign
    case rightBorder_topAlign
    case rightBorder_bottomAlign
}

/// 气泡基础view
open class ZLBubbleBaseView: UIView {

    @objc public dynamic var dismissBlock: (() -> Void)?

    /// 设置ZLBubbleBaseView 本身的frame；.zero ZLBubbleBaseView 默认会和父view四边对齐
    @objc public dynamic var bubbleBackViewFrame: CGRect = .zero

    /// 触摸屏幕，气泡是否自动消失
    @objc public dynamic var autoDismiss: Bool = true
    /// 是否允许气泡背后的view交互
    @objc public dynamic var enableUnderlyingViewInteraction: Bool = false

    /// UI
    @objc public dynamic var bubbleBackColor: UIColor = UIColor(hexString: "14151A", alpha: 0.8) ?? .black

    @objc public dynamic var bubbleBorderColor: UIColor = .clear

    @objc public dynamic var bubbleBorderWidth: CGFloat = 0.0

    @objc public dynamic var bubbleCorner: CGFloat = 2.0

    @objc public dynamic var bubbleInset: UIEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

    /// 三角订单位置 以容器view作为参考坐标系
    @objc public dynamic var trianglePeakPoint: CGPoint = .zero
    /// 三角形大小
    @objc public dynamic var triangleSize: CGSize = CGSize(width: 12, height: 5)
    /// 三角形顶点距离边缘的偏移
    @objc public dynamic var trianglePeakOffsetToBorder: CGFloat = 20
    /// 三角形的位置
    @objc public dynamic var trianglePosition: ZLBubbleViewTrianglePosition = .topBorder_leftAlign

    /// 内容大小
    @objc public dynamic var bubbleContentSize: CGSize = .zero

    /// 气泡 frame
    @objc dynamic var bubbleFrame: CGRect = .zero
    /// 相对气泡内容view frame
    @objc dynamic var relativeContentFrame: CGRect = .zero
    /// 气泡背景图 大小
    @objc dynamic var imageSize: CGSize = .zero
    /// 相对 气泡主体frame。
    @objc dynamic var reletiveBubbleMainBodyFrame: CGRect = .zero
    /// 相对 三角形顶点
    @objc dynamic var relativeTrianglePeakPoints: [CGPoint] = []


    public init() {
        super.init(frame: CGRect(x:0,
                                 y:0,
                                 width:UIScreen.main.bounds.width,
                                 height: UIScreen.main.bounds.height))
        addSubview(bubbleContainerView)
        bubbleContainerView.addSubview(bubbleImageView)
        bubbleContainerView.addSubview(contentView)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc dynamic func keyWindow() -> UIWindow? {
        
        if #available(iOS 13, *) {
            let windows = UIApplication.shared.windows
            for window in windows {
                if window.isKeyWindow {
                    return window
                }
            }
        } else {
            return UIApplication.shared.keyWindow
        }
        
        return nil
    }
    
    @objc dynamic open func showBubble(_ view: UIView? = nil) {

        guard let view = view ?? keyWindow() else {
            return
        }

        caculateSize()

        renderData()

        view.addSubview(self)
        
        setLayout(view)
    }

    @objc dynamic open func caculateContentSize() -> CGSize {
        bubbleContentSize
    }


    @objc dynamic open func caculateSize() {

        /// 内容大小
        let contentSize: CGSize = caculateContentSize()

        /// 气泡主体大小
        let bubbleMainBodySize = CGSize(width: contentSize.width + bubbleInset.left + bubbleInset.right,
                                        height: contentSize.height + bubbleInset.top + bubbleInset.bottom)

        /// imageSize
        var imageSize: CGSize = .zero
        switch trianglePosition {
        case .topBorder_leftAlign, .topBorder_rightAlign, .bottomBorder_leftAlign, .bottomBorder_rightAlign :
            imageSize = CGSize(width: bubbleMainBodySize.width,
                               height: bubbleMainBodySize.height + triangleSize.height)
        case .leftBorder_topAlign, .leftBorder_bottomAlign, .rightBorder_topAlign, .rightBorder_bottomAlign:
            imageSize = CGSize(width: bubbleMainBodySize.width + triangleSize.height,
                               height: bubbleMainBodySize.height)
        }
        imageSize = CGSize(width: imageSize.width + 2 * bubbleBorderWidth,height: imageSize.height + 2 * bubbleBorderWidth)

        /// 气泡主体frame
        var reletiveBubbleMainBodyFrame: CGRect = .zero
        switch trianglePosition {
        case .topBorder_leftAlign, .topBorder_rightAlign:
            reletiveBubbleMainBodyFrame = CGRect(origin: CGPoint(x: 0, y: triangleSize.height),
                                                 size: bubbleMainBodySize)
        case .leftBorder_topAlign, .leftBorder_bottomAlign:
            reletiveBubbleMainBodyFrame = CGRect(origin: CGPoint(x: triangleSize.height, y: 0),
                                                 size: bubbleMainBodySize)
        case .bottomBorder_leftAlign, .bottomBorder_rightAlign, .rightBorder_topAlign, .rightBorder_bottomAlign:
            reletiveBubbleMainBodyFrame = CGRect(origin: .zero,
                                                 size: bubbleMainBodySize)
        }
        reletiveBubbleMainBodyFrame = CGRect(origin: CGPoint(x: reletiveBubbleMainBodyFrame.origin.x + bubbleBorderWidth,
                                                             y: reletiveBubbleMainBodyFrame.origin.y + bubbleBorderWidth),
                                             size: reletiveBubbleMainBodyFrame.size)

        /// 三角形顶点
        var relativeTrianglePeakPoint_0: CGPoint = .zero
        switch trianglePosition {
        case .topBorder_leftAlign:
            relativeTrianglePeakPoint_0 = CGPoint(x: trianglePeakOffsetToBorder, y: 0)
        case .topBorder_rightAlign:
            relativeTrianglePeakPoint_0 = CGPoint(x: bubbleMainBodySize.width - trianglePeakOffsetToBorder, y: 0)
        case .bottomBorder_leftAlign:
            relativeTrianglePeakPoint_0 = CGPoint(x: trianglePeakOffsetToBorder,
                                                  y: bubbleMainBodySize.height + triangleSize.height)
        case .bottomBorder_rightAlign:
            relativeTrianglePeakPoint_0 = CGPoint(x: bubbleMainBodySize.width - trianglePeakOffsetToBorder,
                                                  y: bubbleMainBodySize.height + triangleSize.height)
        case .leftBorder_topAlign:
            relativeTrianglePeakPoint_0 = CGPoint(x: 0, y: trianglePeakOffsetToBorder)
        case .leftBorder_bottomAlign:
            relativeTrianglePeakPoint_0 = CGPoint(x: 0, y: bubbleMainBodySize.height - trianglePeakOffsetToBorder)
        case .rightBorder_topAlign:
            relativeTrianglePeakPoint_0 = CGPoint(x: bubbleMainBodySize.width + triangleSize.height,
                                                  y: trianglePeakOffsetToBorder)
        case .rightBorder_bottomAlign:
            relativeTrianglePeakPoint_0 = CGPoint(x: bubbleMainBodySize.width + triangleSize.height,
                                                  y: bubbleMainBodySize.height - trianglePeakOffsetToBorder)
        }

        switch trianglePosition {
        case .topBorder_leftAlign,.topBorder_rightAlign,.bottomBorder_leftAlign,.bottomBorder_rightAlign :
            relativeTrianglePeakPoint_0 = CGPoint(x: relativeTrianglePeakPoint_0.x,
                                                  y: relativeTrianglePeakPoint_0.y + bubbleBorderWidth)
        case .leftBorder_topAlign,.leftBorder_bottomAlign,.rightBorder_topAlign,.rightBorder_bottomAlign:
            relativeTrianglePeakPoint_0 = CGPoint(x: relativeTrianglePeakPoint_0.x + bubbleBorderWidth,
                                                  y: relativeTrianglePeakPoint_0.y)
        }


        /// 三角形三个顶点
        var relativeTrianglePeakPoints: [CGPoint] = [relativeTrianglePeakPoint_0]

        switch trianglePosition {
        case .topBorder_leftAlign, .topBorder_rightAlign:
            relativeTrianglePeakPoints.append(CGPoint(x: relativeTrianglePeakPoint_0.x - (triangleSize.width / 2.0) ,
                                                     y: triangleSize.height))
            relativeTrianglePeakPoints.append(CGPoint(x: relativeTrianglePeakPoint_0.x + (triangleSize.width / 2.0),
                                                     y: triangleSize.height))
        case .bottomBorder_leftAlign, .bottomBorder_rightAlign:
            relativeTrianglePeakPoints.append(CGPoint(x: relativeTrianglePeakPoint_0.x - (triangleSize.width / 2.0) ,
                                                     y: relativeTrianglePeakPoint_0.y - triangleSize.height))
            relativeTrianglePeakPoints.append(CGPoint(x: relativeTrianglePeakPoint_0.x + (triangleSize.width / 2.0),
                                                     y: relativeTrianglePeakPoint_0.y - triangleSize.height))
        case .leftBorder_topAlign,.leftBorder_bottomAlign:
            relativeTrianglePeakPoints.append(CGPoint(x: triangleSize.height ,
                                                     y: relativeTrianglePeakPoint_0.y - (triangleSize.width / 2.0)))
            relativeTrianglePeakPoints.append(CGPoint(x: triangleSize.height,
                                                     y: relativeTrianglePeakPoint_0.y + (triangleSize.width / 2.0)))
        case .rightBorder_topAlign, .rightBorder_bottomAlign:
            relativeTrianglePeakPoints.append(CGPoint(x: relativeTrianglePeakPoint_0.x - triangleSize.height ,
                                                     y: relativeTrianglePeakPoint_0.y - (triangleSize.width / 2.0)))
            relativeTrianglePeakPoints.append(CGPoint(x: relativeTrianglePeakPoint_0.x - triangleSize.height,
                                                     y: relativeTrianglePeakPoint_0.y + (triangleSize.width / 2.0)))
        }

        /// 气泡文案frame
        let relativeContentFrame = CGRect(x: reletiveBubbleMainBodyFrame.origin.x + bubbleInset.left,
                                        y: reletiveBubbleMainBodyFrame.origin.y + bubbleInset.top,
                                        width: contentSize.width, height: contentSize.height)



        ///
        let bubbleFrame: CGRect = CGRect(x: trianglePeakPoint.x - relativeTrianglePeakPoint_0.x,
                                         y: trianglePeakPoint.y - relativeTrianglePeakPoint_0.y,
                                         width: imageSize.width,
                                         height: imageSize.height)




        self.bubbleFrame = bubbleFrame
        self.relativeContentFrame = relativeContentFrame
        self.imageSize =  imageSize
        self.reletiveBubbleMainBodyFrame = reletiveBubbleMainBodyFrame
        self.relativeTrianglePeakPoints = relativeTrianglePeakPoints

    }

    @objc dynamic open func renderData() {
        bubbleImageView.image = getBubbleBackImageView()
    }


    @objc dynamic open func setLayout(_ view: UIView) {
        frame = bubbleBackViewFrame == .zero ? view.bounds : bubbleBackViewFrame
        bubbleContainerView.frame = convert(bubbleFrame, from: view)
        bubbleImageView.frame = CGRect(x: 0, y: 0, width: bubbleFrame.size.width, height:  bubbleFrame.size.height)
        contentView.frame = relativeContentFrame
    }

    /// 气泡背景图
    @objc dynamic func getBubbleBackImageView() -> UIImage? {

        let renderer = UIGraphicsImageRenderer(size: imageSize)

        let image = renderer.image { context in
            let path = UIBezierPath(roundedRect: self.reletiveBubbleMainBodyFrame,
                                    byRoundingCorners: .allCorners,
                                    cornerRadii: CGSize(width: self.bubbleCorner, height: self.bubbleCorner))
            let trianglePeakPoint_0 = self.relativeTrianglePeakPoints[0]
            let trianglePeakPoint_1 = self.relativeTrianglePeakPoints[1]
            let trianglePeakPoint_2 = self.relativeTrianglePeakPoints[2]
            path.move(to: trianglePeakPoint_0)
            path.addLine(to: trianglePeakPoint_1)
            path.addLine(to: trianglePeakPoint_2)
            path.addLine(to: trianglePeakPoint_0)
            
            path.lineWidth = self.bubbleBorderWidth
            bubbleBorderColor.setStroke()
            path.stroke()
            bubbleBackColor.setFill()
            path.fill(with: .normal, alpha: 1.0)
        }

        return image
    }



    @objc dynamic public lazy var bubbleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    @objc dynamic public lazy var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    @objc dynamic public lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()



    @objc dynamic public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return bubble_hitTest(view: view)
    }

    @objc dynamic open func bubble_hitTest(view: UIView?) -> UIView? {
        /// 自动消失
        if autoDismiss {
            DispatchQueue.main.async {
                self.removeBubbleView()
            }
        }

        if let view = view {
            if view.isDescendant(of: self) {
                /// 点击了气泡部分
                return view
            } else if view == self {
                /// 点击了背景部分
                if enableUnderlyingViewInteraction {
                    /// 如果允许底层view交互
                    return nil
                } else {
                    return view
                }
            }
        }
        return nil
    }


    @objc dynamic public func removeBubbleView() {
        self.removeFromSuperview()
        self.dismissBlock?()
    }
}
