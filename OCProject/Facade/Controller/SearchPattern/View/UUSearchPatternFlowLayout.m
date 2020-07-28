//
//  UUSearchPatternFlowLayout.m
//  OCProject
//
//  Created by Pan on 2020/7/23.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUSearchPatternFlowLayout.h"

@implementation UUSearchPatternFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *tmpArray = [super layoutAttributesForElementsInRect:rect];
    NSArray *attributes = [[NSArray alloc] initWithArray:tmpArray copyItems:YES];
    
    for (NSInteger i = 1; i < attributes.count; i ++) {
        UICollectionViewLayoutAttributes *previousAttribute = attributes[i - 1];
        UICollectionViewLayoutAttributes *currentAttribute = attributes[i];
        
        if (currentAttribute.representedElementCategory != UICollectionElementCategoryCell) continue;
        CGFloat previousMaxX = CGRectGetMaxX(previousAttribute.frame);
        if (previousAttribute.frame.origin.y != currentAttribute.frame.origin.y) continue;
        
        // 相互间距30
        CGRect frame = currentAttribute.frame;
        frame.origin.x = previousMaxX + 30;
        currentAttribute.frame = frame;
    }
    return attributes;
}

@end
