//
//  UUBaseButton.m
//  OCProject
//
//  Created by Pan on 2020/9/19.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUBaseButton.h"

@implementation UUBaseButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    // point是相对位置，0..<width, 0..<height则在内部
    if (point.x >= -(ABS(self.responseEdge.left)) && point.x <= width + ABS(self.responseEdge.right) &&
        point.y >= -(ABS(self.responseEdge.top)) && point.y <= height + ABS(self.responseEdge.bottom)) {
        return [super pointInside:CGPointZero withEvent:event];
    }
    return [super pointInside:point withEvent:event];
}

@end
