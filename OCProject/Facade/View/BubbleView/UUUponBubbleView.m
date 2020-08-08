//
//  UUUponBubbleView.m
//  OCProject
//
//  Created by Pan on 2020/8/8.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUUponBubbleView.h"

@interface UUUponBubbleView ()
{
    CGSize _arrowSize; // 箭头尺寸
}
@end

@implementation UUUponBubbleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _arrowSize = CGSizeMake(15, 11);
        _bubbleColor = UIColor.blueColor;
        _bubbleCorner = 5;
        _labelFont = FONT(14);
        _labelColor = UIColor.whiteColor;
    }
    return self;
}

- (void)dealloc {
    NSLog(@" == %@", [self class]);
}

#pragma mark - Setter

// 气泡内容
- (void)setLabelText:(NSString *)labelText {
    _labelText = [labelText copy];
    [self resetBubbleFrame];
}

// 气泡字体
- (void)setLabelFont:(UIFont *)labelFont {
    _labelFont = labelFont;
    [self resetBubbleFrame];
}

// 重置视图Frame
- (void)resetBubbleFrame {
    if (!_labelText || _labelText.length == 0) {
        self.frame = CGRectZero;
        return;
    }
    NSDictionary *attributes = @{NSFontAttributeName: _labelFont};
    CGSize labelSize = [_labelText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 16 - 16, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:attributes
                                                context:nil].size;
    self.frame = CGRectMake(0, 0, labelSize.width + 16, labelSize.height + _arrowSize.height + 16);
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect {
    if (!_labelText) return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *color = _bubbleColor ? _bubbleColor : UIColor.blueColor;
    [color setFill];
    
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    
    // 圆角气泡
    CGContextMoveToPoint(context,
                         rect.size.width / 2,
                         rect.size.height);
    CGContextAddLineToPoint(context,
                            (rect.size.width - _arrowSize.width) / 2,
                            rect.size.height - _arrowSize.height);
    CGContextAddLineToPoint(context,
                            _bubbleCorner,
                            rect.size.height - _arrowSize.height);
    CGContextAddArc(context,
                    _bubbleCorner,
                    rect.size.height - _arrowSize.height - _bubbleCorner,
                    _bubbleCorner, -M_PI - M_PI_2, -M_PI, 0);
    CGContextAddLineToPoint(context,
                            0, _bubbleCorner * 2);
    CGContextAddArc(context,
                    _bubbleCorner,
                    _bubbleCorner,
                    _bubbleCorner, -M_PI, -M_PI_2, 0);
    CGContextAddLineToPoint(context,
                            rect.size.width - _bubbleCorner, 0);
    CGContextAddArc(context,
                    rect.size.width - _bubbleCorner,
                    _bubbleCorner,
                    _bubbleCorner, -M_PI_2, 0, 0);
    CGContextAddLineToPoint(context,
                            rect.size.width,
                            rect.size.height - _arrowSize.height - _bubbleCorner);
    CGContextAddArc(context,
                    rect.size.width - _bubbleCorner,
                    rect.size.height - _arrowSize.height - _bubbleCorner,
                    _bubbleCorner, 0, M_PI_2, 0);
    CGContextAddLineToPoint(context,
                            (rect.size.width + _arrowSize.width) / 2,
                            rect.size.height - _arrowSize.height);
    CGContextAddLineToPoint(context,
                            rect.size.width / 2,
                            rect.size.height);
    CGContextFillPath(context);
    
    // 文字
    CGRect labelRect = CGRectMake(8, 8, rect.size.width - 15, rect.size.height - _arrowSize.height - 15);
    NSDictionary *attributes = @{NSFontAttributeName: self.labelFont, NSForegroundColorAttributeName: self.labelColor};
    [_labelText drawInRect:labelRect withAttributes:attributes];

    CGContextRestoreGState(context);
}

@end
