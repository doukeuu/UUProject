//
//  UUSegmentButtonView.swift
//  SwiftProject
//
//  Created by Pan on 2020/8/28.
//  Copyright © 2020 xyz. All rights reserved.
//

import UIKit

@objc protocol UUSegmentButtonViewDelegate: NSObjectProtocol {
    /// 点击按钮的代理，index按钮下标
    @objc optional
    func segmentButtonView(_ view: UUSegmentButtonView, didClickAt index: Int)
}


class UUSegmentButtonView: UIView {

    private var _scrollView: UIScrollView!     // 滚动视图
    private var _markLineLayer: CALayer?       // 按钮下面标记线
    private var _separatorLayer: CALayer?      // 底部分割线
    private var _selectedButton: UIButton!     // 选择的按钮
    
    private var _buttonArray = [UIButton]()    // 按钮数组
    private var _widthArray = [CGFloat]()      // 按钮内容宽度数组
    private var _allTitleWidth: CGFloat = 0.0  // 按钮内容总宽度，用于设置间距
    
    private let _badgeTag = -110110            // 角标标签tag值
    private let _badgeWidth: CGFloat = 16.0    // 角标标签宽度
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        generateScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    
    // 生成滚动视图
    private func generateScrollView() {
        _scrollView = UIScrollView(frame: self.bounds)
        _scrollView.backgroundColor = UIColor.white
        _scrollView.showsHorizontalScrollIndicator = false
        _scrollView.showsVerticalScrollIndicator = false
        self.addSubview(_scrollView)
    }
    
    // 按钮下面标记线
    private func generateMarkLine() {
        _markLineLayer = CALayer()
        _markLineLayer?.backgroundColor = COLOR_THEME.cgColor
        _scrollView.layer.addSublayer(_markLineLayer!)
    }
    
    // 视图下分割线
    private func generateSeparatorLine() {
        _separatorLayer = CALayer()
        _separatorLayer?.frame = CGRect(x: 0, y: self.bounds.height - 1, width: self.bounds.width, height: 1)
        _separatorLayer?.backgroundColor = UIColor.backLightGray.cgColor
        self.layer.addSublayer(_separatorLayer!)
    }
    
    // 生成按钮视图
    private func generateButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = normalFont
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(normalTextColor, for: .normal)
        button.setTitleColor(selectTextColor, for: .selected)
        button.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
        return button
    }
    
    // 角标标签
    private func generateBadgeLabel(for button: UIButton) -> UILabel {
        let badgeLabel = button.viewWithTag(_badgeTag) as? UILabel
        if badgeLabel != nil { return badgeLabel! }
        let label = UILabel()
        label.tag = _badgeTag
        label.frame = CGRect(x: 0, y: 0, width: _badgeWidth, height: _badgeWidth)
        label.backgroundColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.layer.cornerRadius = _badgeWidth/2
        label.layer.masksToBounds = true
        button.addSubview(label)
        return label
    }
    
    // MARK: - Public Property
    
    /// 滚动视图
    var scrollView: UIScrollView { _scrollView }
    
    /// 按钮下面标记线
    var markLine: CALayer {
        if _markLineLayer == nil {
            generateMarkLine()
        }
        return _markLineLayer!
    }
    
    /// 下分割线
    var separatorLine: CALayer {
        if _separatorLayer == nil {
            generateSeparatorLine()
        }
        return _separatorLayer!
    }
    
    /// 标题数组
    var titleArray: [String] = [] {
        didSet {
            if oldValue == titleArray { return }
            balanceButtonCount()
        }
    }
    
    /// 图标名称数组
    var imageArray: [String] = [] {
        didSet {
            if oldValue == imageArray { return }
            balanceButtonCount()
        }
    }
    
    /// 选中时图标名称数组
    var selectedImages: [String] = [] {
        didSet { updateButtonStyle() }
    }
    
    /// 当前选择下标
    var currentIndex: Int = 0 {
        willSet {
            if newValue == currentIndex { return }
            if newValue < 0 || newValue >= _buttonArray.count { return }
            resetCurrentButton(_buttonArray[newValue])
        }
    }
    
    /// 按钮左右内边距
    var buttonPadding: CGFloat = 0.0 {
        didSet { setNeedsLayout() }
    }
    
    /// 按钮边距
    var marginInsets: UIEdgeInsets = .zero {
        didSet { setNeedsLayout() }
    }

    /// 是否等间距
    var isEqualMargin: Bool = true
    
    /// 按钮常态字体
    var normalFont = UIFont.systemFont(ofSize: 17) {
        didSet { updateButtonStyle() }
    }
    
    /// 按钮选中字体
    var selectFont = UIFont.systemFont(ofSize: 17, weight: .medium) {
        didSet { updateButtonStyle() }
    }
    
    /// 按钮常态颜色
    var normalTextColor = UIColor.black {
        didSet { updateButtonStyle() }
    }
    
    /// 按钮选中颜色
    var selectTextColor = UIColor.blue {
        didSet { updateButtonStyle() }
    }
    
    /// 按钮常态背景色
    var normalBackColor: UIColor? {
        didSet { updateButtonStyle() }
    }
    
    /// 按钮选中背景色
    var selectBackColor: UIColor? {
        didSet { updateButtonStyle() }
    }
    
    /// 圆角半径
    var cornerRadius: CGFloat = 0.0 {
        didSet { updateButtonStyle() }
    }
    
    /// 图表与标题位置
    var positionStyle = UIButton.ImageTitlePosition.imageLeftTitleRight
    
    /// 图标与标题间距
    var positionSpace: CGFloat = 0.0
    
    /// 按钮下面标记线固定宽度
    var markLineWidth: CGFloat = 0.0 {
        didSet {
            markLine.isHidden = false
            layoutMarkLineLayer()
        }
    }
    
    /// 角标是原点还是数字
    var isDotBadge: Bool = true {
        didSet { _buttonArray.forEach { updateBadgeLabel(in: $0) } }
    }
        
    /// 代理
    weak var delegate: UUSegmentButtonViewDelegate?
    
    
    // MARK: - Pulibc Method
    
    /// 根据按钮下标设置角标
    func setupBadge(_ number: Int, at index: Int) {
        if index < 0 || index >= _buttonArray.count { return }
        let button = _buttonArray[index]
        let label = generateBadgeLabel(for: button)
        label.text = number <= 0 ? "" : (number > 999 ? "999" : "\(number)")
        updateBadgeLabel(in: button)
    }
    
    // MARK: - Update
    
    // 保持按钮数与标题及图表数量最大值相等
    private func balanceButtonCount() {
        let titleCount = titleArray.count
        let imageCount = imageArray.count
        let buttonCount = _buttonArray.count
        let bigger = max(titleCount, imageCount)
        let biggest = max(bigger, buttonCount)
        
        for i in 0 ..< biggest {
            if i >= bigger {
                let button = _buttonArray.last
                button?.removeFromSuperview()
                _buttonArray.removeLast()
                continue
            }
            if i >= buttonCount {
                let button = generateButton()
                _scrollView.addSubview(button)
                _buttonArray.append(button)
            }
        }
        updateButtonStyle()
    }
    
    // 更新按钮属性设置
    private func updateButtonStyle() {
        let titleCount = titleArray.count
        let imageCount = imageArray.count
        let selectedCount = selectedImages.count
        let bigger = max(titleCount, imageCount)
        
        let normalBackImage = imageFromColor(normalBackColor)
        let selectBackImage = imageFromColor(selectBackColor)
        
        _widthArray.removeAll()
        _allTitleWidth = 0.0
        
        for j in 0 ..< bigger {
            let title = j < titleCount ? titleArray[j] : nil
            let imageName = imageCount == 0 ? nil : imageArray[j % imageCount]
            let imageSelected = selectedCount == 0 ? nil : selectedImages[j % selectedCount]
            let button = _buttonArray[j]
            
            button.titleLabel?.font = normalFont
            button.setTitleColor(normalTextColor, for: .normal)
            button.setTitleColor(selectTextColor, for: .selected)
            button.setTitle(title, for: .normal)
            
            if imageName != nil {
                button.setImage(UIImage(named: imageName!), for: .normal)
            }
            if imageSelected != nil {
                button.setImage(UIImage(named: imageSelected!), for: .selected)
            }
            if normalBackImage != nil {
                button.setBackgroundImage(normalBackImage, for: .normal)
            }
            if selectBackImage != nil {
                button.setBackgroundImage(selectBackImage, for: .selected)
            }
            if cornerRadius > 0.0 {
                button.layer.cornerRadius = cornerRadius
                button.layer.masksToBounds = true
            }
            let titleWidth = button.titleLabel?.intrinsicContentSize.width ?? 0.0
            let imageWidth = button.imageView?.intrinsicContentSize.width ?? 0.0
            var contentWidth = titleWidth + imageWidth + positionSpace
            if positionStyle == .imageTopTitleDown || positionStyle == .imageDownTitleTop {
               contentWidth = max(titleWidth, imageWidth)
            }
            _widthArray.append(contentWidth)
            _allTitleWidth += contentWidth
            
            if j == currentIndex {
                button.isSelected = true
                button.titleLabel?.font = selectFont
                _selectedButton = button
            }
            button.tag = j
        }
    }
    
    // 重新设置当前按钮样式
    private func resetCurrentButton(_ button: UIButton) {
        button.isSelected = true
        button.titleLabel?.font = selectFont
        button.resetImageTitlePosition(positionStyle, space: positionSpace)
        layoutBadgeLabel(in: button)
        
        _selectedButton.isSelected = false
        _selectedButton.titleLabel?.font = normalFont
        _selectedButton.resetImageTitlePosition(positionStyle, space: positionSpace)
        layoutBadgeLabel(in: _selectedButton)
        
        _selectedButton = button
        layoutMarkLineLayer()
        
        let rect = button.frame.insetBy(dx: -(buttonPadding + 10), dy: 0)
        _scrollView.scrollRectToVisible(rect, animated: true)
    }
    
    // 更新按钮中角标样式状态
    private func updateBadgeLabel(in button: UIButton) {
        guard let label = button.viewWithTag(_badgeTag) as? UILabel else { return }
        label.textColor = isDotBadge ? UIColor.red : UIColor.white
        label.isHidden = label.text?.isEmpty ?? true
        layoutBadgeLabel(in: button)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let count = _buttonArray.count
        if count == 0 { return }
        
        let width = _scrollView.bounds.width
        let height = _scrollView.bounds.height
        let maxMargin = max(marginInsets.left, marginInsets.right)
        let bothMargin = marginInsets.left + marginInsets.right
        
        var spacing = (width - _allTitleWidth - CGFloat(count + 1) * maxMargin) / CGFloat(count) / 2.0
        if !isEqualMargin { spacing = ((width - _allTitleWidth) / CGFloat(count) - bothMargin) / 2.0 }
        if buttonPadding > 0 { spacing = buttonPadding } // 设置固定左右内间距
        
        var buttonX = isEqualMargin ? maxMargin : marginInsets.left
        let marginRight = isEqualMargin ? maxMargin : marginInsets.right
        let buttonH = height - marginInsets.top - marginInsets.bottom
        
        for i in 0 ..< count {
            let button = _buttonArray[i]
            let titleWidth = _widthArray[i]
            let buttonWidth = titleWidth + spacing * 2.0
            button.frame = CGRect(x: buttonX, y: marginInsets.top, width: buttonWidth, height: buttonH)
            
            buttonX += buttonWidth + (isEqualMargin ? maxMargin : bothMargin)
            button.resetImageTitlePosition(positionStyle, space: positionSpace)
            layoutBadgeLabel(in: button)
        }
        
        let button = _buttonArray[count - 1]
        _scrollView.contentSize = CGSize(width: button.frame.maxX + marginRight, height: height)
        layoutMarkLineLayer()
    }
    
    // 设置标记线frame
    private func layoutMarkLineLayer() {
        guard let button = _selectedButton, let markLineLayer = _markLineLayer else { return }

        let titleWidth = button.titleLabel?.intrinsicContentSize.width ?? 0.0
        let imageWidth = button.imageView?.intrinsicContentSize.width ?? 0.0
        var contentWidth = titleWidth + imageWidth + positionSpace
        if positionStyle == .imageTopTitleDown || positionStyle == .imageDownTitleTop {
           contentWidth = max(titleWidth, imageWidth)
        }
        
        let markWidth = markLineWidth > 0 ? markLineWidth : contentWidth
        let markX = button.frame.minX + (button.frame.width - markWidth) / 2.0
        let tmpHeight = _markLineLayer?.frame.height ?? 0.0
        let markHeight = tmpHeight > 0.0 ? tmpHeight : 2.0
        let markY = _scrollView.frame.height - markHeight - 1
        markLineLayer.frame = CGRect(x: markX, y: markY, width: markWidth, height: markHeight)
    }

    // 设置按钮中角标的frame
    private func layoutBadgeLabel(in button: UIButton) {
        guard let label = button.viewWithTag(_badgeTag) as? UILabel else { return }
        
        let imageFrame = button.imageView?.frame ?? .zero
        let titleFrame = button.titleLabel?.frame ?? .zero
        let offset = isDotBadge ? _badgeWidth/4 : _badgeWidth/2
        
        let badgeX = max(imageFrame.maxX, titleFrame.maxX) - offset
        var minY = min(imageFrame.minY, titleFrame.minY)
        if minY == 0.0 { minY = max(imageFrame.minY, titleFrame.minY) }
        let badgeY = minY - offset
        
        label.frame.origin = CGPoint(x: badgeX, y: badgeY)
        if isDotBadge {
            label.layer.cornerRadius = _badgeWidth/4
            label.frame.size = CGSize(width: _badgeWidth/2, height: _badgeWidth/2)
        } else {
            let width = label.intrinsicContentSize.width + _badgeWidth/2
            label.layer.cornerRadius = _badgeWidth/2
            label.frame.size = CGSize(width: max(width, _badgeWidth), height: _badgeWidth)
        }
    }
    
    // MARK: - Respond

    // 点击按钮
    @objc private func clickButton(_ button: UIButton) {
        if button.isSelected { return }
        currentIndex = button.tag
        delegate?.segmentButtonView?(self, didClickAt: button.tag)
    }

    // MARK: - Utility
    
    // 生成纯色图片
    private func imageFromColor(_ color: UIColor?) -> UIImage? {
        guard let fillColor = color else { return nil }
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(fillColor.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
